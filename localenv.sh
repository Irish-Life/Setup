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

sudo -u "$SUDO_USER" echo "$(brew install git)"

if [ $? == 0 ]
then echo "Git installed! Remember to configure your user.name and user.email..."
else echo "Git installation failed.."
exit $?
fi


echo "Installing composer..."

sudo -u "$SUDO_USER" "`brew install composer`"

if [ $? == 0 ]
then echo "Composer installed!"
else echo "Composer installation failed.." 
exit $?
fi

echo "Preparing to install Yarn..."

sudo -u "$SUDO_USER" "`brew install yarn`"

if [ $? == 0 ]
then echo "Yarn installed!"
else echo "Yarn installation failed.."
exit $?
fi


echo "Moving to htdocs..."

`cd /Applications/MAMP/htdocs` || exit

echo "Done"

echo "Preparing to create Drupal 8 installation..."

sudo -u "$SUDO_USER" echo "`composer create-project drupal-composer/drupal-project:8.x-dev /Applications/MAMP/htdocs/bline --stability dev --no-interaction --no-install`"

if [ $? == 0 ]
then echo "Drupal installed!"
else echo "Drupal installation failed.."
exit $?
fi

echo "Setting up vhosts..."

vhost="

<VirtualHost *:80>
    DocumentRoot /Applications/MAMP/htdocs/bline
    ServerName bline.local
</VirtualHost>
"
echo "$vhost" >> /Applications/MAMP/conf/apache/extra/httpd-vhosts.conf

host="127.0.0.1   bline.local"

sudo -u "$SUDO_USER" echo "$host" >> /etc/hosts



if [ $? == 0 ]
then echo "Created vhosts!"
else echo "Vhost creation failed.."
exit $?
fi

echo "Moving to bline folder..."

"`cd bline`" || exit

echo "Done"

echo "Preparing to install emulsify..."

sudo -u "$SUDO_USER" echo "`composer require fourkitchens/emulsify`"

if [ $? == 0 ]
then echo "Emulsify installed!"
else echo "Installation failed.."
exit $?
fi

echo "Creating child theme..."

"`cd web/themes/contrib/emulsify`" || exit

sudo -u "$SUDO_USER" echo "`php emulsify.php bline`"

if [ $? == 0 ]
then echo "Child theme created!"
else echo "Child theme creation failed.."
exit $?
fi

echo "Installing child theme..."

"`cd ../../custom/bline`"

sudo -u "$SUDO_USER" echo "`yarn`"

if [ $? == 0 ]
then echo "Child theme installed!"
else echo "Child theme installation failed.."
exit $?
fi

echo "Installing drush..."

sudo -u "$SUDO_USER" echo "`composer global require drush/drush:dev-master`"

if [ $? == 0 ]
then echo "Drush installed!"
else echo "Installation failed.."
exit $?
fi

echo "Adding to path..."

"`export PATH="$HOME/.composer/vendor/bin:$PATH"`"

echo "Done"

echo "Enabling modules and bline child theme theme"

echo "Moving back to project root..."

"`cd ../../../../`" || exit

sudo -u "$SUDO_USER" echo "`drush then bline -y \&\& drush en components unified_twig_ext -y`"

if [ $? == 0 ]
then echo "Theme and modules enabled!"
else echo "Enabling modules failed.."
exit $?
fi

echo "Finished!!"

exit $?