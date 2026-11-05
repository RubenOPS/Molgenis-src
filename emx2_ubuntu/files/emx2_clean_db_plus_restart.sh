#!/bin/bash

# Exit on any error
set -e

# Step 1: Notify the user about cleanup
echo "Starting the cleanup process using /usr/local/share/molgenis/tools/emx2_clean_database.sh..."
# Run the cleanup script
/usr/local/share/molgenis/tools/emx2_clean_database.sh

# Check if the cleanup script ran successfully
if [ $? -eq 0 ]; then
    echo "Cleanup completed successfully."
else
    echo "Cleanup script encountered an error!" >&2
    exit 1
fi

# Step 2: Notify the user about service restart
echo "Restarting emx2.service..."
# Restart the service
systemctl restart emx2.service


# Check if the service restart succeeded
if [ $? -eq 0 ]; then
    echo "emx2.service restarted successfully."
else
    echo "Failed to restart emx2.service!" >&2
    exit 1
fi

#Step3: restart prometheus-postgres-exporter
echo "Restarting prometheus postgres exporter"
systemctl restart prometheus-postgres-exporter

