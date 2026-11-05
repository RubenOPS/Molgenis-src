#!/bin/bash

echo "################################################################################"
echo "Start wipe of emx2 vm"
echo "--------------------------------------------------------------------------------"
echo "Stop and disable systemd services"

# stop systemd services
systemctl stop emx2
systemctl stop nginx
systemctl stop filebeat
systemctl stop node_exporter
systemctl stop postgresql
systemctl stop prometheus-nginx-exporter
systemctl stop prometheus-postgres-exporter


# disable systemd services
systemctl disable emx2
systemctl disable nginx
systemctl disable filebeat
systemctl disable node_exporter
systemctl disable prometheus-nginx-exporter
systemctl disable prometheus-postgres-exporter

echo "--------------------------------------------------------------------------------"
echo "Remove installed packages via apt"

# remove every installed application
apt remove --purge --allow-change-held-packages -y postgresql-15 postgresql-client-15 postgresql postgresql-contrib python3-psycopg2 nginx net-tools ntp prometheus-nginx-exporter prometheus-postgres-exporter

echo "--------------------------------------------------------------------------------"
echo "Remove held back files not needed"

rm -rf /usr/local/bin/node_exporter
rm -rf /etc/systemd/system/emx2.service
rm -rf /etc/systemd/system/node_exporter.service
rm -Rf /etc/default/prometheus-*-exporter
rm -rf /usr/lib/systemd/system/emx2*
rm -rf /usr/lib/systemd/system/node_exporter*
rm -rf /home/molgenis/*
rm -rf /srv/molgenis*
rm -rf /data/*
rm -rf /var/lib/pgsql/*
rm -rf /usr/local/share/molgenis*
rm -rf /usr/share/filebeat*
rm -rf /etc/filebeat*
rm -rf /etc/apt/sources.list.d/elastic-7.x.list
mv /var/lib/postgresql /var/lib/postgresql.backup

systemctl daemon-reload
systemctl reset-failed

echo "--------------------------------------------------------------------------------"
echo "Wipe emx2 vm done"
echo "################################################################################"
