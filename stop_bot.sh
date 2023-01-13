#!/usr/bin/env bash

echo """
Available ENV variables to configure the bot:
---------------------------------------------
- HBOT_ID: The unique ID of the bot
- HBOT_PSK: The auth password of the bot
- HBOT_FILE: The configuration file to load on startup
- HBOT_TUI: Enable/Disable the TUI (Terminal-based User Interface)
"""

if [ -z $HBOT_ID ]; then
    read -p "[*] Enter hbot ID --> " HBOT_ID
fi
if [ "$HBOT_ID" == "" ]; then
    HBOT_ID=$(python  -c 'import uuid; print(uuid.uuid4())')
fi

docker container kill hbot-${HBOT_ID}
