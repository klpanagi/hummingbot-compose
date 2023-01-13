#!/usr/bin/env bash

export HBOT_COMPOSE_FILE=./hbot.compose.yml
export HOST_DOCKER=/var/run/docker.sock

docker compose -f hbot.compose.yml run  \
    --rm                                \
    --name hbot-db                      \
    db

exit

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

