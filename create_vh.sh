#!/bin/bash

path="/etc/apache2/sites-available/"
fileExists=true
fileType=".conf"

if [ -w $path ]
then
     echo "File has write permission, proceeding"
else
     echo "You don't have write permission, try running as sudo"
     exit 1
fi

while [[ "$fileExists" != "false" ]]
do

echo "Please enter the name for the config file that will be created for the virtual host"
read vh

if [[ -f "$path$vh$fileType" ]]; then
    echo "$path$vh already exists! Please choose another name"
    else
    echo "Creating config file"
    touch "$path$vh.conf"
    fileExists=false
fi
done

echo "Please specify the absolute path of the document root (the folder with the website) eg: /var/www/html/test"
read documentRoot

echo "Please specify the name of the directory index eg: index.html"
read directoryIndex

echo "The name of the subdomain eg: subdomain.domain.tld"
read serverName

cat >$path$vh$fileType <<EOF
<VirtualHost *:80>
    DocumentRoot $documentRoot
    ServerName $serverName
    <Directory $documentRoot>
        AllowOverride None
        DirectoryIndex $directoryIndex
    </Directory>
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

echo "File created successfully! You can find it at $path$vh$fileType"

echo "Enabling the conf file"
a2ensite $vh$fileType

if [ $? -eq 0 ]; then
    echo "Your configuration file has been enabled successfully! Remember to reload or restart apache to apply changes!"
else
    echo "Enabling the configuration file failed!"
fi



