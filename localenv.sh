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

cd /Applications/MAMP/htdocs || exit

echo "Done"

echo "Preparing to create Drupal 8 installation..."

read -p "What will you call your site? " site

composer create-project drupal-composer/drupal-project:8.x-dev /Applications/MAMP/htdocs/$site --no-interaction

if [ $? == 0 ]
then echo "Drupal installed!"
else echo "Drupal installation failed.."
exit $?
fi

echo "Moving to $site folder..."

cd /Applications/MAMP/htdocs/$site || exit

echo "Done"

echo "Preparing to install emulsify..."

composer require fourkitchens/emulsify

if [ $? == 0 ]
then echo "Emulsify installed!"
else echo "Installation failed.."
exit $?
fi

echo "Cloning child theme..."

mkdir /Applications/MAMP/htdocs/$site/web/themes/custom/

cd /Applications/MAMP/htdocs/$site/web/themes/custom || exit

git clone https://github.com/Irish-Life/bline.git

cd bline || exit

yarn

echo "Done"

echo "Installing drush..."

cd /Applications/MAMP/htdocs/$site || exit

composer global require drush/drush:dev-master

curl -OL https://github.com/drush-ops/drush-launcher/releases/download/0.6.0/drush.phar

`chmod +x drush.phar`

`mv drush.phar /usr/local/bin/drush`

if [ $? == 0 ]
then echo "Drush installed!"
else echo "Installation failed.."
exit $?
fi

echo "Configuring drupal..."

read -p "Enter your database username: " dbusername

read -p "And the password: " dbpword

read -p "And the database name: " dbname

read -p "And the name of the site (Note, this should be the same value as specified earlier when setting up vhosts): " sitename

cd /Applications/MAMP/htdocs/$site || exit

echo "Configuring settings.php..."

settings="
 \$databases['default']['default'] = array (
   'database' => '$dbname',
   'username' => '$dbusername',
   'password' => '$dbpword',
   'prefix' => '',
   'host' => '127.0.0.1',
   'port' => '3306',
   'namespace' => 'Drupal\\Core\\Database\\Driver\\mysql',
   'driver' => 'mysql',
 );"


echo "$settings" >> /Applications/MAMP/htdocs/$site/web/sites/default/settings.php

#drush si standard --db-url=mysql://$dbusername:$dbpword@127.0.0.1/$dbname --site-name=$sitename

if [ $? == 0 ]
then echo "Settings configured!"
else echo "Configuration failed.."
exit $?
fi

echo "Enabling modules and bline child theme theme"

echo "Moving back to project root..."

cd /Applications/MAMP/htdocs/$site || exit

drush then bline -y && drush en components unified_twig_ext -y

if [ $? == 0 ]
then echo "Theme and modules enabled!"
else echo "Enabling modules failed.."
exit $?
fi


echo "Finished!!"

exit $?
