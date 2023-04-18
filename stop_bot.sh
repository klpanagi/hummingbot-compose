#!/usr/bin/env bash

CONTAINER_PREFIX="hbot-"
COMPOSE_FILE_NAME="hbot.compose.yml"

help()
{
    echo "
Usage: ./stop_bot.sh [ -n | --id ]
                     [ -h | --help  ]"
    exit 2
}

SHORT=n:,h
LONG=id:,help
OPTS=$(getopt -a -n rm_bot.sh --options $SHORT --longoptions $LONG -- "$@")

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
    echo "[X] Error: HBOT_ID not set!"
    exit 1
fi

CONTAINER_NAME="${CONTAINER_PREFIX}${HBOT_ID}"

docker container stop ${CONTAINER_NAME}
