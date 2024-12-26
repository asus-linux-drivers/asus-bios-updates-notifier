#!/usr/bin/env bash

function check_bios_update() {
    local BIOS_PRODUCT_NAME="$1"
    local BIOS_VERSION="$2"

    echo
    echo "Product: $BIOS_PRODUCT_NAME"
    echo "BIOS version: $BIOS_VERSION"

    USER_AGENT="user-agent-name-here"
    BIOS_PRODUCT_NAME_LOWER=$(echo "$BIOS_PRODUCT_NAME" | tr '[:upper:]' '[:lower:]')
    CURL_LAPTOP_SUPPORT_PAGE_URL="https://www.asus.com/us/supportonly/$BIOS_PRODUCT_NAME_LOWER/helpdesk_bios/"
    LAPTOP_SUPPORT_PAGE_CURL=$(curl -s --user-agent "$USER_AGENT" "$CURL_LAPTOP_SUPPORT_PAGE_URL")

    BIOS_VERSION_LATEST=$(echo "$LAPTOP_SUPPORT_PAGE_CURL" | xmllint --html --xpath "(//div[contains(@class, 'ProductSupportDriverBIOS__fileInfo')])[1]/div[1]/text()" - 2>/dev/null | cut -d ' ' -f 2)
    BIOS_VERSION_LATEST_RELEASED_DATE=$(echo "$LAPTOP_SUPPORT_PAGE_CURL" | xmllint --html --xpath "(//div[contains(@class, 'ProductSupportDriverBIOS__fileInfo')])[1]/div[3]/text()" - 2>/dev/null)
    BIOS_VERSION_LATEST_RELEASED_DATE=$(echo "$BIOS_VERSION_LATEST_RELEASED_DATE" | xargs)

    if [[ "$BIOS_VERSION_LATEST" == "$BIOS_VERSION" ]]; then
        echo "BIOS $BIOS_VERSION is up-to-date"

        if [ "$BIOS_IS_UPTODATE_SCRIPT_FILE_PATH" ]; then
            source "$BIOS_IS_UPTODATE_SCRIPT_FILE_PATH"
        fi
    else
        echo "BIOS is upgradable to: $BIOS_VERSION_LATEST"
        echo "Download link: $CURL_LAPTOP_SUPPORT_PAGE_URL"

        if [ "$BIOS_IS_UPGRADABLE_SCRIPT_FILE_PATH" ]; then
            source "$BIOS_IS_UPGRADABLE_SCRIPT_FILE_PATH"
        fi
    fi
}

# check current laptop bios
CURRENT_LAPTOP_BIOS=$(cat /sys/class/dmi/id/bios_version)
CURRENT_LAPTOP_BIOS_PRODUCT_NAME=$(echo "$CURRENT_LAPTOP_BIOS" | cut -d '.' -f 1 | cut -d '_' -f 1)
CURRENT_LAPTOP_BIOS_VERSION=$(echo "$CURRENT_LAPTOP_BIOS" | cut -d '.' -f 2)

check_bios_update "$CURRENT_LAPTOP_BIOS_PRODUCT_NAME" "$CURRENT_LAPTOP_BIOS_VERSION"

# check bios for each product in the config
if [ -f "$CONFIG_DIR_PATH/config.ini" ]; then

  # Loop through each line in the config file
  while IFS='=' read -r BIOS_PRODUCT_NAME BIOS_VERSION; do

    BIOS_PRODUCT_NAME=$(echo "$BIOS_PRODUCT_NAME" | xargs | tr -d '"' | tr -d '\r')
    BIOS_VERSION=$(echo "$BIOS_VERSION" | xargs | tr -d '"' | tr -d '\r')

    check_bios_update "$BIOS_PRODUCT_NAME" "$BIOS_VERSION"
  done < "$CONFIG_DIR_PATH/config.ini"
else
  echo "not found $CONFIG_DIR_PATH/config.ini"
fi