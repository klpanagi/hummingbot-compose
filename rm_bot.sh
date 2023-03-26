#!/usr/bin/env bash

if [ -z $HBOT_ID ]; then
    read -p "[*] Enter hbot ID --> " HBOT_ID
fi
if [ "$HBOT_ID" == "" ]; then
    echo "Bot ID not given!"
    exit
fi

docker container rm hbot-${HBOT_ID}
docker volume rm                \
    hbot-${HBOT_ID}-data        \
    hbot-${HBOT_ID}-conf        \
    hbot-${HBOT_ID}-logs        \
    hbot-${HBOT_ID}-scripts     \
    hbot-${HBOT_ID}-pmmscripts  \
