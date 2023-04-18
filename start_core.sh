#!/usr/bin/env bash

COMPOSE_FILENAME="core.compose.yml"

help()
{
    echo "
Usage: ./start_core.sh [ --no-gw ]
                       [ --no-mqtt ]
                       [ --no-db ]
                       [ --no-obs ]
                       [ --no-analysis ]
                       [ --no-tv ]
                       [ -h | --help ]"
    exit 2
}

SHORT=h
LONG=no-gw,no-db,no-mqtt,no-obs,no-analysis,no-tv,help
OPTS=$(getopt -a -n rm_bot.sh --options $SHORT --longoptions $LONG -- "$@")

VALID_ARGUMENTS=$# # Returns the count of arguments that are in short or long options

eval set -- "$OPTS"

while :
do
  case "$1" in
    --no-analysis )
      EXCLUDE_ANALYSIS=1
      shift;
      ;;
    --no-db )
      EXCLUDE_DB=1
      shift;
      ;;
    --no-gw )
      EXCLUDE_GATEWAY=1
      shift;
      ;;
    --no-obs )
      EXCLUDE_OBS=1
      shift;
      ;;
    --no-mqtt )
      EXCLUDE_MQTT=1
      shift;
      ;;
    --no-tv )
      EXCLUDE_TRADINGVIEW=1
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

PROFILES=""

if [ -z $EXCLUDE_GATEWAY ]; then
 PROFILES="${PROFILES} --profile gateway"
fi
if [ -z $EXCLUDE_DB ]; then
 PROFILES="${PROFILES} --profile db"
fi
if [ -z $EXCLUDE_MQTT ]; then
 PROFILES="${PROFILES} --profile mqtt"
fi
if [ -z $EXCLUDE_OBS ]; then
 PROFILES="${PROFILES} --profile obs"
fi
if [ -z $EXCLUDE_ANALYSIS ]; then
 PROFILES="${PROFILES} --profile analysis"
fi
if [ -z $EXCLUDE_TRADINGVIEW ]; then
 PROFILES="${PROFILES} --profile tradingview"
fi

docker compose -f ${COMPOSE_FILENAME} down &&   \
    docker compose -f ${COMPOSE_FILENAME}       \
    ${PROFILES}                                 \
    up --remove-orphans
