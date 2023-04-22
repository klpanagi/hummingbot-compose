#!/usr/bin/env bash

set -e
set -o pipefail

CONTAINER_PREFIX="hbot-"
COMPOSE_FILE_NAME="hbot.compose.yml"
ENV_FILE=".env"

help()
{
    echo "
Usage: ./start_bot.sh [ -n | --id ]
                      [ -p | --psk ]
                      [ -f | --strategy-file ]
                      [ -d | --detach ]
                      [ -h | --help  ]"
    exit 2
}

SHORT=n:,p:,f:,d:,h
LONG=id:,psk:,strategy-file:,detach,help
OPTS=$(getopt -a -n start_bot.sh --options $SHORT --longoptions $LONG -- "$@")

VALID_ARGUMENTS=$# # Returns the count of arguments that are in short or long options

if [ "$VALID_ARGUMENTS" -eq 0 ]; then
  help
fi

eval set -- "$OPTS"

while :
do
  case "$1" in
    -n | --id )
      HBOT_ID="$2"
      shift 2
      ;;
    -p | --psk )
      HBOT_PSK="$2"
      shift 2
      ;;
    -f | --strategy-file )
      HBOT_FILE="$2"
      shift 2
      ;;
    -d | --detach )
      DETACH=1
      shift;
      ;;
    -h | --help)
      help
      ;;
    --)
      shift;
      break
      ;;
    *)
      echo "Unexpected option: $1"
      help
      ;;
  esac
done

if [ -z $HBOT_ID ]; then
    HBOT_ID=$(python  -c 'import uuid; print(uuid.uuid4())')
fi
if [ "$HBOT_ID" == "" ]; then
    HBOT_ID=$(python  -c 'import uuid; print(uuid.uuid4())')
fi

CONTAINER_NAME=${CONTAINER_PREFIX}${HBOT_ID}

set -o allexport
source $ENV_FILE
set +o allexport

echo """
Creating hbot container with

    Bot Parameters:
    - Id: ${HBOT_ID}
    - Passphrase: ${HBOT_PSK}
    - Strategy file: ${HBOT_FILE}
    - Detach: ${DETACH}

    Deployment Parameters:
    - Image: ${HBOT_IMAGE}
    - Memory Limit (Mb): ${HBOT_MEM_LIMIT}
    - Memory Reservation (Mb): ${HBOT_MEM_RESERVATION}
"""

if [ "$(docker ps -q -f name=${CONTAINER_NAME})" ]; then
    echo "[*] Instance ${CONTAINER_NAME} already running."
    exit 1
fi

if [ ! -z $DETACH ]; then
    DETACH_CONTAINER="--detach"
else
    DETACH_CONTAINER=""
fi

HBOT_ID=${HBOT_ID} HBOT_PSK=${HBOT_PSK} HBOT_FILE=${HBOT_FILE}  \
    docker compose -f ${COMPOSE_FILE_NAME} run                  \
    --rm                                                        \
    ${DETACH_CONTAINER}                                         \
    --name ${CONTAINER_NAME}                                    \
    hbot
