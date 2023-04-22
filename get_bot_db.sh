#!/usr/bin/env bash

CONTAINER_PREFIX="hbot-"

help()
{
    echo "Usage: ./rm_bot.sh [ -n | --id ]
                             [ -h | --help  ]"
    exit 2
}

SHORT=n:,h
LONG=id:,help
OPTS=$(getopt -a -n ls_bot.sh --options $SHORT --longoptions $LONG -- "$@")

VALID_ARGUMENTS=$# # Returns the count of arguments that are in short or long options

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

CONTAINER_ID=$(docker run -d -v hbot-${HBOT_ID}-data:/hbot-data busybox true)
docker cp $CONTAINER_ID:/hbot-data ./hbot-${HBOT_ID}-data
