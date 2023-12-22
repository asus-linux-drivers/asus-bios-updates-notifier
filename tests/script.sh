#!/usr/bin/env bash

PAGE=1

USER_AGENT="user-agent-name-here"
# TODO: test not only all ZenBooks
ASUS_DEVICE_LIST_URL="https://linux-hardware.org/?view=computers&type=Notebook&vendor=ASUSTek+Computer&model=ZenBook+%28All%29&page=$PAGE"
ASUS_DEVICES_LIST_CURL=$(curl -s --user-agent "$USER_AGENT" "$ASUS_DEVICE_LIST_URL" )

DEVICE_URLS=$(echo $ASUS_DEVICES_LIST_CURL | xmllint --html --xpath "//a[contains(@title, 'computer info')]/@href" - 2>/dev/null)

while [[ "$DEVICE_URLS" ]]; do

    IFS=' ' read -r -a array1 <<< $(echo $DEVICE_URLS)

    for INDEX in "${!array1[@]}"
    do
        echo $PAGE-$INDEX

        DEVICE_URL=$(echo "${array1[INDEX]}" | cut -d '"' -f2)

        echo $DEVICE_URL

        ASUS_DEVICE_CURL=$(curl -s --user-agent "$USER_AGENT" "https://linux-hardware.org$DEVICE_URL" )

        PROBE_URLS=$(echo $ASUS_DEVICE_CURL | xmllint --html --xpath "//a[contains(@title, 'probe info')]/@href" - 2>/dev/null)

        IFS=' ' read -r -a array2 <<< $(echo $PROBE_URLS)
        for INDEX in "${!array2[@]}"
        do
            PROBE_URL=$(echo "${array2[INDEX]}" | cut -d '"' -f2)

            echo $PROBE_URL

            ASUS_PROBE_CURL=$(curl -s --user-agent "$USER_AGENT" "https://linux-hardware.org$PROBE_URL" )

            BIOS=$(echo $ASUS_PROBE_CURL | xmllint --html --xpath "//td[contains(@class, 'device') and contains(text(), 'BIOS')]/text()" - 2>/dev/null | cut -d ' ' -f2)

            echo $BIOS

            # Main script of notifier
            source script.sh

            if [[ $? != 0 ]]; then
                echo "Something went wrong when searching for BIOS upgrade of $BIOS"
                exit 1
            fi

            # Test only one of found probes of each device (BIOS should be the same)
            break
        done
    done

    PAGE=$(($PAGE+1))

    # TODO: test not only all ZenBooks
    ASUS_DEVICE_LIST_URL="https://linux-hardware.org/?view=computers&type=Notebook&vendor=ASUSTek+Computer&model=ZenBook+%28All%29&page=$PAGE"
    ASUS_DEVICES_LIST_CURL=$(curl -s --user-agent "$USER_AGENT" "$ASUS_DEVICE_LIST_URL" )

    DEVICE_URLS=$(echo $ASUS_DEVICES_LIST_CURL | xmllint --html --xpath "//a[contains(@title, 'computer info')]/@href" - 2>/dev/null)
done