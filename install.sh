#!/bin/sh

read -p "What is the name of the site (Note, this should be the same value as specified earlier when setting up vhosts): " sitename

cd /Applications/MAMP/htdocs/$sitename || exit

#drush si standard --site-name=$sitename
#this is stephens bit
#conor testing
#more test comment