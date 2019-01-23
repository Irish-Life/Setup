echo "Setting up httpd vhosts..."

vhost="

<VirtualHost *:80>
    DocumentRoot /Applications/MAMP/htdocs/bline/web
    ServerName bline.test
</VirtualHost>
"
echo "$vhost" >> /Applications/MAMP/conf/apache/extra/httpd-vhosts.conf

echo "Setting up /etc/hosts file..."

host="127.0.0.1   bline.test"

echo "$host" >> /etc/hosts

killall -HUP mDNSResponder

if [ $? == 0 ]
then echo "Created vhosts!"
else echo "Vhost creation failed.."
exit $?
fi