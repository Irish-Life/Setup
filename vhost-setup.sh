echo "Setting up httpd vhosts..."
read -p 'Enter a name for your local site: ' name
vhost="

<VirtualHost *:80>
    DocumentRoot /Applications/MAMP/htdocs/bline/web
    ServerName $name
</VirtualHost>
"
echo "$vhost" >> /Applications/MAMP/conf/apache/extra/httpd-vhosts.conf

echo "Setting up /etc/hosts file..."

host="127.0.0.1   $name"

echo "$host" >> /etc/hosts

killall -HUP mDNSResponder

if [ $? == 0 ]
then echo "Created vhosts!"
else echo "Vhost creation failed.."
exit $?
fi