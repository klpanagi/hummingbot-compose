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

export HBOT_IMAGE="klpanagi/hummingbot:latest"
export HBOT_COMPOSE_FILE=./hbot.compose.yml
export HOST_DOCKER=/var/run/docker.sock
export HBOT_ID=$HBOT_ID

if [ ! "$(docker ps -q -f name=hbot-${HBOT_ID})" ]; then
    if [ "$(docker ps -aq -f status=exited -f name=hbot-${HBOT_ID})" ]; then
        # cleanup
        echo "[*] Instance hbot-${HBOT_ID} exists but exited. Removing..."
        docker rm hbot-${HBOT_ID}
    fi
else
    while true
    do
        read -p \
            "[*] Instance hbot-${HBOT_ID} is running. Do you want to kill first? (y/n/Y/N) " \
            attach
        case "$attach" in
          n|N) exit;;
          y|Y) docker kill hbot-${HBOT_ID}; break;;
          *) echo 'Response not valid';;
        esac
    done
fi

docker compose -f hbot.compose.yml run  \
    --rm                                \
    --detach                            \
    --name                              \
    hbot-${HBOT_ID}                     \
    hbot

while true
do
    read -p "[*] Attach to the hbot-${HBOT_ID} instance? (y/n/Y/N) " attach
    case "$attach" in
      n|N) break;;
      y|Y) docker attach "hbot-${HBOT_ID}"; break;;
      *) echo 'Response not valid';;
    esac
done

