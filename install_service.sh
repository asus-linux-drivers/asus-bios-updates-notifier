#!/bin/bash

source non_sudo_check.sh

# INHERIT VARS
if [ -z "$INSTALL_DIR_PATH" ]; then
    INSTALL_DIR_PATH="/usr/share/asus-bios-updates-notifier"
fi
if [ -z "$LOGS_DIR_PATH" ]; then
    LOGS_DIR_PATH="/var/log/asus-bios-updates-notifier"
fi

echo "Systemctl service"
echo

read -r -p "Do you want install systemctl service? [y/N]" RESPONSE
case "$RESPONSE" in [yY][eE][sS]|[yY])

    SERVICE_FILE_PATH=asus_bios_updates_notifier.service
    SERVICE_INSTALL_FILE_NAME="asus_bios_updates_notifier@.service"
    SERVICE_INSTALL_DIR_PATH="/usr/lib/systemd/user"

    ERROR_LOG_FILE_PATH="$LOGS_DIR_PATH/error.log"

    BIOS_IS_UPGRADABLE_SCRIPT_FILE_PATH="$INSTALL_DIR_PATH/bios_is_upgradable_script.sh"
    cat "bios_is_upgradable_script.sh" | sudo tee "$BIOS_IS_UPGRADABLE_SCRIPT_FILE_PATH" >/dev/null
    sudo chmod +x $BIOS_IS_UPGRADABLE_SCRIPT_FILE_PATH

    BIOS_IS_UPTODATE_SCRIPT_FILE_PATH="$INSTALL_DIR_PATH/bios_is_uptodate_script.sh"
    cat "bios_is_uptodate_script.sh" | sudo tee "$BIOS_IS_UPTODATE_SCRIPT_FILE_PATH" >/dev/null
    sudo chmod +x $BIOS_IS_UPTODATE_SCRIPT_FILE_PATH

    echo
    echo "UPGRADABLE SCRIPT: $BIOS_IS_UPTODATE_SCRIPT_FILE_PATH"
    echo "UPTODATE SCRIPT: $BIOS_IS_UPTODATE_SCRIPT_FILE_PATH"
    echo

    DBUS_SESSION_BUS_ADDRESS=$(echo $DBUS_SESSION_BUS_ADDRESS)

    echo
    echo "ERROR LOG FILE: $ERROR_LOG_FILE_PATH"
    echo
    echo "env var DBUS_SESSION_BUS_ADDRESS: $DBUS_SESSION_BUS_ADDRESS"
    echo

    cat "$SERVICE_FILE_PATH" | ERROR_LOG_FILE_PATH=$ERROR_LOG_FILE_PATH BIOS_IS_UPGRADABLE_SCRIPT_FILE_PATH=$BIOS_IS_UPGRADABLE_SCRIPT_FILE_PATH BIOS_IS_UPTODATE_SCRIPT_FILE_PATH=$BIOS_IS_UPTODATE_SCRIPT_FILE_PATH DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS envsubst '$ERROR_LOG_FILE_PATH $BIOS_IS_UPGRADABLE_SCRIPT_FILE_PATH $BIOS_IS_UPTODATE_SCRIPT_FILE_PATH $DBUS_SESSION_BUS_ADDRESS' | sudo tee "$SERVICE_INSTALL_DIR_PATH/$SERVICE_INSTALL_FILE_NAME" >/dev/null

    if [[ $? != 0 ]]; then
        echo "Something went wrong when moving the $SERVICE_FILE_PATH"
        exit 1
    else
        echo "Asus bios updates notifier service placed"
    fi

    systemctl --user daemon-reload

    if [[ $? != 0 ]]; then
        echo "Something went wrong when was called systemctl daemon reload"
        exit 1
    else
        echo "Systemctl daemon reloaded"
    fi

    systemctl enable --user asus_bios_updates_notifier@$USER.service

    if [[ $? != 0 ]]; then
        echo "Something went wrong when enabling the asus_bios_updates_notifier@$USER.service"
        exit 1
    else
        echo "Asus bios updates notifier service enabled"
    fi

    systemctl restart --user asus_bios_updates_notifier@$USER.service
    if [[ $? != 0 ]]; then
        echo "Something went wrong when starting the asus_bios_updates_notifier@$USER.service"
        exit 1
    else
        echo "Asus bios updates notifier service started"
    fi
esac