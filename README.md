# Irish Life Drupal Install Scripts
Script and documentation for setting up a new development environment based on Drupal 8 with Composer etc.


## Preface
In order to run the scripts and install a development environment, first you will need to install a local development server.

We tend to use [MAMP](https://www.mamp.info/en/) but there are other options available such as [XAMP](https://www.apachefriends.org/).

However it should be noted that this guide / these scripts are intended for use with MAMP and some customisation may be required in order to get them to work correctly with other local servers.

## Installation Procedure

* **Install MAMP**
* **Change default port settings** - MAMP uses ports 8888 and 8889 for HTTP and MySQL respectively. In order to prevent having a localhost address such as http://bline.test:8888 we configure MAMP to use the standard ports.
  Run MAMP from your Finder. Applications > MAMP. When booted, click the MAMP menu item and select "Preferences". You will see a tab menu with a "Ports" tab.
  Click onto the ports tab and click the button to "Set Web & MySQL ports to 80 and 3306".
  Then click "Ok"
* **Create database and user** - We need to create a database and database user for later on in the process when we are installing Drupal. MAMP provides an out of the box installation for phpmyadmin which makes this fairly easy.
  On the main MAMP dashboard click the "Start Servers" button.
  Once all items go green a new browser window will pop up with the MAMP welcome screen.
  Click the "Tools" dropdown menu and select "PHPMYADMIN".
  Phpmyadmin should open in a new tab.
  Click the "User accounts" button in the top navigation bar.
  Underneath the list of existing users, click the "Add user account" link.
  Enter a username and password. Leave the hostname as the default.
  Directly beneath this form you will see a checkbox labelled "Create a database with same name and grant all privileges"
  Click the checkbox and then click the "Go" button at the bottom right of the page.
  Your database should now be created. Keep a note of the details you entered as we will need these to fill out the Drupal settings file.
* **Configure MAMP to use virtual hosts** - MAMP bundles the apache webserver which needs to be configured to use the virtual hosts module. This lets us serve multiple sites from the same IP address.
  Open /Applications/MAMP/conf/apache/httpd.conf - the main apache config file.
  Find and uncomment the line "Include /Applications/MAMP/conf/apache/extra/httpd-vhosts.conf" by removing the leading #.
  You may need to open this file will admin / sudo privileges.
  
## Run the scripts
The two scripts in this repo can now be executed in order to complete the installation procedure.
First, run vhost-setup.sh with elevated privileges.
From the terminal, run:
```shell
sudo bash vhost-setup.sh
```
Enter your password and wait for the script to finish. This should take less than a second if successful.

Next execute the localenv.sh script **without** elevated privileges.
From the terminal, run:
```shell
bash localenv.sh
```
This will begin the installation process including setting up the following:

1. Homebrew - mac package manager
2. Git - version control system
3. Composer - php package manager
4. Yarn - javascript / general package manager
5. Drupal 8 - cms the site runs on
6. Emulsify - the parent drupal theme we extend from
7. Patternlab - the component based pattern library built into emulsify
8. bline - our extended theme

This script will take some time to install as it involves pulling in a lot of packages etc. Go make a :coffee:

## Finishing up
Once that's all done, the last thing to do is to enable the theme and its dependant modules.

Make sure your MAMP server is running and enter http://bline.test into your browsers address bar.

At this point, if all has gone well, you should be presented with the standard Drupal installation screen.

Follow the prompts on screen specifying the database name and user etc. from earlier.

When entering your Drupal username, the convention is to use "admin".

Once that installs you should end up on the home screen for default drupal. Click the "Extend" button in the top navigation. This will present you with a list of modules installed on the site.
Scroll down until you see "Drupal Pattern Lab" and check the "Unified Twig Extensions" checkbox if it isn't already checked.

Scroll a little further and check the "Other" > "Component Libraries" checkbox. Then click the "Install" button at the bottom of the page.

Next, click into the "Appearance" button in the top navigation. This will show you all currently installed themes on the site.

Scroll down to see the "bline" theme.

Click the button to "Install and Set as Default"

Congratulations! You've built your local dev environment.





