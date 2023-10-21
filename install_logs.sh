#!/bin/bash

source non_sudo_check.sh

# INHERIT
if [ -z "$LOGS_DIR_PATH" ]; then
    LOGS_DIR_PATH="/var/log/asus-bios-updates-notifier"
fi

sudo groupadd "biosupdatesnotifier"

sudo usermod -a -G "biosupdatesnotifier" $USER

if [[ $? != 0 ]]; then
    echo "Something went wrong when adding the group biosupdatesnotifier to current user"
    exit 1
else
    echo "Added group biosupdatesnotifier to current user"
fi

sudo mkdir -p "$LOGS_DIR_PATH"
sudo chown -R :biosupdatesnotifier "$LOGS_DIR_PATH"
sudo chmod -R g+w "$LOGS_DIR_PATH"