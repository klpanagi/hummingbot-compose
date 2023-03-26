#!/usr/bin/env bash

if [ -z $HBOT_ID ]; then
    read -p "[*] Enter hbot ID --> " HBOT_ID
fi
if [ "$HBOT_ID" == "" ]; then
    HBOT_ID=$(python  -c 'import uuid; print(uuid.uuid4())')
fi

docker container kill hbot-${HBOT_ID}
