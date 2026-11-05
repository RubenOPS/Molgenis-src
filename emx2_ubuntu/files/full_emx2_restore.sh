#!/bin/sh

# stop emx2
systemctl stop emx2
# Stop prometheus-postgres-exporter
systemctl stop prometheus-postgres-exporter

# cleanup old database content
/usr/local/share/molgenis/tools/emx2_clean_database.sh

# load data in molgenis database
chmod o+r /tmp/postgresql.sql
su - postgres -c "/usr/bin/psql -f /tmp/postgresql.sql > /tmp/restore_out.txt 2>&1"

# start emx2
systemctl start emx2

#start prometheus-postgres-exporter
systemctl start prometheus-postgres-exporter
# cleanup /tmp
rm -f /tmp/postgresql.sql
rm -f /tmp/filestore_backup.tgz
