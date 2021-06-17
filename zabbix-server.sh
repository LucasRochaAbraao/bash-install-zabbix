#!/bin/sh
sudo apt install -y wget
wget https://repo.zabbix.com/zabbix/5.0/debian/pool/main/z/zabbix-release/zabbix-release_5.0-1+buster_all.deb
dpkg -i zabbix-release_5.0-1+buster_all.deb
apt update
apt install -y zabbix-server-pgsql zabbix-frontend-php php7.3-pgsql zabbix-apache-conf zabbix-agent

apt install -y postgresql postgresql-contrib
systemctl enable --now postgresql@11-main

sudo -u postgres createuser --pwprompt zabbix
sudo -u postgres createdb -O zabbix -E Unicode -T template0 zabbix

zcat /usr/share/doc/zabbix-server-pgsql*/create.sql.gz | sudo -u zabbix psql zabbix

echo "DBPassword=password" >> /etc/zabbix/zabbix_server.conf
echo "php_value date.timezone America/Sao_Paulo" >> /etc/zabbix/apache.conf

systemctl restart zabbix-server zabbix-agent apache2
systemctl enable zabbix-server zabbix-agent apache2
