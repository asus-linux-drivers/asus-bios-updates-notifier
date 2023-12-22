#!/bin/bash

if [ -z "$BIOS" ]; then
    BIOS=$(cat /sys/class/dmi/id/bios_version)
fi

echo

BIOS_PRODUCT_NAME=$(echo $BIOS | cut -d '.' -f 1)
BIOS_VERSION=$(echo $BIOS | cut -d '.' -f 2)

echo "Detected laptop: $BIOS_PRODUCT_NAME"
echo "Detected BIOS version: $BIOS_VERSION"

# 1st attempt - odinapi
USER_AGENT="user-agent-name-here"
CURL_LAPTOP_LIST_URL="https://odinapi.asus.com/recent-data/apiv2/SearchResult?SystemCode=asus&WebsiteCode=global&SearchKey=$BIOS_PRODUCT_NAME&SearchType=products&PageSize=50&Pages=1&LocalFlag=0&siteID=www&sitelang="
LAPTOP_LIST_CURL=$(curl -s --user-agent "$USER_AGENT" "$CURL_LAPTOP_LIST_URL" )

# take only first product url (e.g. ROG Zephyrus G16 GU603ZI has multiple)
LAPTOP_HELPDESK_BIOS=$(echo $LAPTOP_LIST_CURL | jq -r '[.Result.List[].ProductURL][0]' | tr '[:upper:]' '[:lower:]')
LAPTOP_PD_WEB_PATH=$(echo $LAPTOP_LIST_CURL | jq -r '[.Result.List[].PDWebPath][0]' | tr '[:upper:]' '[:lower:]')

# 2nd attempt - directly support page when odinapi does not return any product
if [ -z "$LAPTOP_HELPDESK_BIOS" ]; then
    BIOS_PRODUCT_NAME_LOWER=$(echo $BIOS_PRODUCT_NAME | tr '[:upper:]' '[:lower:]')
    CURL_LAPTOP_SUPPORT_PAGE_URL="https://www.asus.com/supportonly/$BIOS_PRODUCT_NAME_LOWER/helpdesk_bios/"
else 
    CURL_LAPTOP_SUPPORT_PAGE_URL="${LAPTOP_HELPDESK_BIOS}helpdesk_bios/?model2Name=${LAPTOP_PD_WEB_PATH}"
fi

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