FROM ubuntu:18.04

RUN apt-get update -y
RUN apt-get upgrade -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install apache2 mariadb-server libapache2-mod-php7.2 php7.2 php7.2-cli php7.2-mysql php7.2-common php7.2-zip php7.2-mbstring php7.2-xmlrpc php7.2-curl php7.2-soap php7.2-gd php7.2-xml php7.2-intl php7.2-ldap php7.2-imap unzip wget curl -y
RUN ln -fs /usr/share/zoneinfo/Europe/Paris /etc/localtime
RUN dpkg-reconfigure --frontend noninteractive tzdata


RUN curl -o vtigercrm.tar.gz -SL https://excellmedia.dl.sourceforge.net/project/vtigercrm/vtiger%20CRM%207.1.0/Core%20Product/vtigercrm7.1.0.tar.gz
RUN tar -xzf vtigercrm.tar.gz
RUN cp -r vtigercrm /var/www/html/
RUN chown -R www-data:www-data /var/www/html/vtigercrm
RUN chmod -R 755 /var/www/html/vtigercrm

COPY vtigercrm.conf /etc/apache2/sites-available/
COPY php.ini /etc/php/7.2/apache2/

RUN a2ensite vtigercrm
RUN a2dissite 000-default
RUN a2enmod rewrite

COPY run.sh .
RUN chmod +x run.sh
COPY docker-entrypoint.sh /entrypoint.sh

EXPOSE 80
VOLUME ["/var/www/html/vtigercrm"]
ENTRYPOINT ["/entrypoint.sh"]
CMD ["./run.sh"]


