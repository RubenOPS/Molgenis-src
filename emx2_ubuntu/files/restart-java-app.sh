#!/bin/bash

# Check if any OpenJDK package (JDK or JRE) is installed and updated
if dpkg-query -W -f='${Status}' openjdk-* 2>/dev/null | grep -q "install ok installed"; then
    # Log the action to syslog for tracking
    logger -t apt-hook "OpenJDK update detected, restarting emx2.service"
    
    # Restart your application service
    systemctl restart emx2.service
fi
