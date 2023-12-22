#!/usr/bin/env bash

if [ -z "$BIOS" ]; then
    BIOS=$(cat /sys/class/dmi/id/bios_version)
fi

echo

BIOS_PRODUCT_NAME=$(echo $BIOS | cut -d '.' -f 1)
BIOS_VERSION=$(echo $BIOS | cut -d '.' -f 2)

echo "Detected laptop: $BIOS_PRODUCT_NAME"
echo "Detected BIOS version: $BIOS_VERSION"

USER_AGENT="user-agent-name-here"
BIOS_PRODUCT_NAME_LOWER=$(echo $BIOS_PRODUCT_NAME | tr '[:upper:]' '[:lower:]')
CURL_LAPTOP_SUPPORT_PAGE_URL="https://www.asus.com/supportonly/$BIOS_PRODUCT_NAME_LOWER/helpdesk_bios/"

LAPTOP_SUPPORT_PAGE_CURL=$(curl -s --user-agent "$USER_AGENT" "$CURL_LAPTOP_SUPPORT_PAGE_URL" )

BIOS_VERSION_LATEST=$(echo $LAPTOP_SUPPORT_PAGE_CURL | xmllint --html --xpath "(//div[contains(@class, 'ProductSupportDriverBIOS__fileInfo')])[1]/div[1]/text()" - 2>/dev/null | cut -d ' ' -f 2)
BIOS_VERSION_LATEST_RELEASED_DATE=$(echo $LAPTOP_SUPPORT_PAGE_CURL | xmllint --html --xpath "(//div[contains(@class, 'ProductSupportDriverBIOS__fileInfo')])[1]/div[3]/text()" - 2>/dev/null)

echo

if [[ "$BIOS_VERSION_LATEST" != "$BIOS_VERSION" ]]; then
    echo "BIOS is upgradable to $BIOS_VERSION_LATEST"
    echo "Download link: $CURL_LAPTOP_SUPPORT_PAGE_URL"

    if [ "$BIOS_IS_UPGRADABLE_SCRIPT_FILE_PATH" ]; then
        source $BIOS_IS_UPGRADABLE_SCRIPT_FILE_PATH
    fi
else
    echo "BIOS $BIOS_VERSION is up-to-date"

    if [ "$BIOS_IS_UPTODATE_SCRIPT_FILE_PATH" ]; then
        source $BIOS_IS_UPTODATE_SCRIPT_FILE_PATH
    fi
fi