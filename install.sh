#!/bin/bash

source non_sudo_check.sh

LOGS_DIR_PATH="/var/log/asus-bios-updates-notifier"

source install_logs.sh

echo

# log output from every installing attempt aswell
LOGS_INSTALL_LOG_FILE_NAME=install-"$(date +"%d-%m-%Y-%H-%M-%S")".log
LOGS_INSTALL_LOG_FILE_PATH="$LOGS_DIR_PATH/$LOGS_INSTALL_LOG_FILE_NAME"

{
    if [[ $(sudo apt-get install 2>/dev/null) ]]; then
        sudo apt-get -y install curl libxml2-utils jq
    elif [[ $(sudo pacman -h 2>/dev/null) ]]; then
        sudo pacman --noconfirm --needed -S curl libxml2 jq
    elif [[ $(sudo dnf help 2>/dev/null) ]]; then
        sudo dnf -y install curl libxml2 jq
    elif [[ $(sudo yum help 2>/dev/null) ]]; then
        # yum was replaced with newer dnf above
        sudo yum --y install curl libxml2 jq
    else
        echo "Not detected package manager. Driver may not work properly because required packages have not been installed. Please create an issue (https://github.com/asus-linux-drivers/asus-bios-updates-notifier/issues)."
    fi

    INSTALL_DIR_PATH="/usr/share/asus-bios-updates-notifier"

    sudo mkdir -p "$INSTALL_DIR_PATH"
    sudo chown -R $USER "$INSTALL_DIR_PATH"
    sudo install script.sh "$INSTALL_DIR_PATH"
    sudo chmod +x "$INSTALL_DIR_PATH/script.sh"

    echo

    source install_service.sh

} 2>&1 | sudo tee "$LOGS_INSTALL_LOG_FILE_PATH"