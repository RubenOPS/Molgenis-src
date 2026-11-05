#!/bin/bash
# This bash script will do the following:
# - Drop and recreate all the tables inside the molgenis schema
MOLGENIS_OPS_TOOLS=/usr/local/share/molgenis/tools/
MOLGENIS_HOME="/usr/local/share/molgenis/"
echo "################################################################################"
echo "Start cleanup of database"
echo "--------------------------------------------------------------------------------"
echo "Check if EMX2 is running"
if [[ $(sudo systemctl status emx2) = *"running"* ]]; then
  sudo systemctl stop emx2
fi

echo "Check if Prometheus PGSQL Exporter is running"
if [[ $(sudo systemctl status prometheus-postgres-exporter) = *"running"* ]]; then
  sudo systemctl stop prometheus-postgres-exporter 
fi

echo "Dropping molgenis schema tables and triggers"
if [[ $(whoami) = "root"* ]]; then
  RUN_PSQL="sudo -i -u postgres psql -U postgres -q"
else
  RUN_PSQL="psql -U postgres -q"
fi

${RUN_PSQL} <<SQL
DROP DATABASE molgenis;
CREATE USER placeholder_role;
DO \$\$DECLARE r record;
BEGIN
    FOR r IN select rolname from pg_roles where rolname like 'MG%'
    LOOP
       	EXECUTE 'REASSIGN OWNED BY '|| quote_ident(r.rolname) ||'TO placeholder_role';
        EXECUTE 'DROP OWNED BY '|| quote_ident(r.rolname);
        EXECUTE 'DROP ROLE ' || quote_ident(r.rolname);
    END LOOP;
END\$\$;
CREATE DATABASE molgenis OWNER = molgenis;
SQL
echo "--------------------------------------------------------------------------------"
echo "Cleanup is done"
echo "--------------------------------------------------------------------------------"
