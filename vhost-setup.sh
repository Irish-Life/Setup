echo "Setting up httpd vhosts..."

vhost="

<VirtualHost *:80>
    DocumentRoot /Applications/MAMP/htdocs/bline
    ServerName bline.local
</VirtualHost>
"
echo "$vhost" >> /Applications/MAMP/conf/apache/extra/httpd-vhosts.conf

echo "Setting up /etc/hosts file..."

host="127.0.0.1   bline.local"

echo $host >> /etc/hosts

if [ $? == 0 ]
then echo "Created vhosts!"
else echo "Vhost creation failed.."
exit $?
fi