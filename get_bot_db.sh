#!/usr/bin/env bash

CONTAINER_PREFIX="hbot-"

help()
{
    echo """
Usage: ./get_bot_db.sh [ -n | --id ]
                       [ -o | --outdir ]
                       [ -h | --help ]
"""
    exit 2
}

SHORT=n:,o:,h
LONG=id:,output:,help
OPTS=$(getopt -a -n get_bot_db.sh --options $SHORT --longoptions $LONG -- "$@")

VALID_ARGUMENTS=$# # Returns the count of arguments that are in short or long options

eval set -- "$OPTS"

while :
do
  case "$1" in
    -n | --id )
      HBOT_ID="$2"
      shift 2
      ;;
    -o | --outdir )
      OUTDIR="$2"
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

if [ -z $OUTDIR ]; then
    OUTDIR=./hbot-${HBOT_ID}-data
fi


CONTAINER_ID=$(docker run -d -v hbot-${HBOT_ID}-data:/hbot-data busybox true)
docker cp ${CONTAINER_ID}:/hbot-data ${OUTDIR}
