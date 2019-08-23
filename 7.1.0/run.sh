#!/bin/sh
chown -R www-data:www-data /var/www/html/vtigercrm/storage /var/www/html/vtigercrm/logs
chmod -R 755 /var/www/html/vtigercrm/storage /var/www/html/vtigercrm/logs
apachectl -D FOREGROUND
