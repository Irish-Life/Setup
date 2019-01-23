#!/bin/sh

echo "Starting installation process.."

echo "Installing Homebrew..."

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

if [ $? == 0 ]
then echo "Homebrew installed!"
else echo "Homebrew installation failed.."
exit $?
fi

echo "Installing Git..."

brew install git

if [ $? == 0 ]
then echo "Git installed! Remember to configure your user.name and user.email..."
else echo "Git installation failed.."
exit $?
fi


echo "Installing composer..."

brew install composer

if [ $? == 0 ]
then echo "Composer installed!"
else echo "Composer installation failed.." 
exit $?
fi

echo "Preparing to install Yarn..."

brew install yarn

if [ $? == 0 ]
then echo "Yarn installed!"
else echo "Yarn installation failed.."
exit $?
fi


echo "Moving to htdocs..."

`cd /Applications/MAMP/htdocs || exit`

echo "Done"

echo "Preparing to create Drupal 8 installation..."

composer create-project drupal-composer/drupal-project:8.x-dev /Applications/MAMP/htdocs/bline --stability dev --no-interaction --no-install

if [ $? == 0 ]
then echo "Drupal installed!"
else echo "Drupal installation failed.."
exit $?
fi

echo "Moving to bline folder..."

cd /Applications/MAMP/htdocs/bline || exit

echo "Done"

echo "Preparing to install emulsify..."

composer require fourkitchens/emulsify

if [ $? == 0 ]
then echo "Emulsify installed!"
else echo "Installation failed.."
exit $?
fi

echo "Creating child theme..."

cd /Applications/MAMP/htdocs/bline/web/themes/contrib/emulsify || exit

php emulsify.php bline

if [ $? == 0 ]
then echo "Child theme created!"
else echo "Child theme creation failed.."
exit $?
fi

echo "Installing child theme..."

`cd /Applications/MAMP/htdocs/bline/web/themes/custom/bline || exit`

yarn

if [ $? == 0 ]
then echo "Child theme installed!"
else echo "Child theme installation failed.."
exit $?
fi

echo "Installing drush..."

composer global require drush/drush:dev-master

curl -OL https://github.com/drush-ops/drush-launcher/releases/download/0.6.0/drush.phar

`chmod +x drush.phar`

`mv drush.phar /usr/local/bin/drush`

if [ $? == 0 ]
then echo "Drush installed!"
else echo "Installation failed.."
exit $?
fi

echo "Adding to path..."

export PATH="$HOME/drush:$PATH"
echo $PATH
echo "Done"

echo "Configuring settings.php..."

settings="
\$databases['default']['default'] = array (
  'database' => 'bline-test',
  'username' => 'bline-test',
  'password' => 'password',
  'prefix' => '',
  'host' => 'localhost',
  'port' => '3306',
  'namespace' => 'Drupal\\Core\\Database\\Driver\\mysql',
  'driver' => 'mysql',
);"

echo "$settings" >> /Applications/MAMP/htdocs/bline/web/sites/default/settings.php

if [ $? == 0 ]
then echo "Settings configured!"
else echo "Configuration failed.."
exit $?
fi

echo "Enabling modules and bline child theme theme"

echo "Moving back to project root..."

`cd /Applications/MAMP/htdocs/bline || exit`

drush then bline -y && drush en components unified_twig_ext -y

if [ $? == 0 ]
then echo "Theme and modules enabled!"
else echo "Enabling modules failed.."
exit $?
fi

echo "Finished!!"

exit $?
