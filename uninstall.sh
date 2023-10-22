#!/bin/bash

source non_sudo_check.sh

LOGS_DIR_PATH="/var/log/asus-bios-updates-notifier"

# log output from every uninstalling attempt aswell
LOGS_UNINSTALL_LOG_FILE_NAME=uninstall-"$(date +"%d-%m-%Y-%H-%M-%S")".log
LOGS_UNINSTALL_LOG_FILE_PATH="$LOGS_DIR_PATH/$LOGS_UNINSTALL_LOG_FILE_NAME"
touch "$LOGS_UNINSTALL_LOG_FILE_PATH"

{
    INSTALL_DIR_PATH="/usr/share/asus-bios-updates-notifier"
 
    sudo rm -rf $INSTALL_DIR_PATH

    if [[ $? != 0 ]]
	then
	    echo "Something went wrong when removing files from the $INSTALL_DIR_PATH"
	fi

	echo "Asus numberpad driver removed"

	echo

	source uninstall_service.sh

	echo

	echo "Uninstallation finished succesfully"

	echo

	read -r -p "Reboot is required. Do you want reboot now? [y/N]" RESPONSE
    case "$RESPONSE" in [yY][eE][sS]|[yY])
        reboot
        ;;
    *)
        ;;
    esac

	exit 0
} 2>&1 | sudo tee "$LOGS_UNINSTALL_LOG_FILE_PATH"