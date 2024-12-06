#!/usr/bin/env bash

COMPOSE_FILENAME="core.compose.yml"
ENV_FILE=".env"

EXCLUDE_DB=1
EXCLUDE_TRADINGVIEW=1
EXCLUDE_DASHBOARD=1
EXCLUDE_MQTT=1

help()
{
    echo "
Usage: ./start_core.sh [ --no-gw ]
                       [ --no-mqtt ]
                       [ --db ]
                       [ --tv ]
                       [ -h | --help ]"
    exit 2
}

SHORT=h
LONG=no-gw,db,no-mqtt,tv,help
OPTS=$(getopt -a -n start_core.sh --options $SHORT --longoptions $LONG -- "$@")

VALID_ARGUMENTS=$# # Returns the count of arguments that are in short or long options

eval set -- "$OPTS"


while :
do
  case "$1" in
    --db )
      unset EXCLUDE_DB
      shift;
      ;;
    --no-gw )
      EXCLUDE_GATEWAY=1
      shift;
      ;;
    --no-mqtt )
      EXCLUDE_MQTT=1
      shift;
      ;;
    --tv )
      unset EXCLUDE_TRADINGVIEW
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
if [ -z $EXCLUDE_DASHBOARD ]; then
 PROFILES="${PROFILES} --profile dashboard"
fi
if [ -z $EXCLUDE_TRADINGVIEW ]; then
 PROFILES="${PROFILES} --profile tradingview"
fi

set -o allexport
source $ENV_FILE
set +o allexport

echo """
Starting Hummingbot Core...

    Gateway Parameters:
    - Image: ${GW_IMAGE}
    - Port: ${GW_PORT}
    - Passphrase: ${GW_PASSPHRASE}

    MQTT Broker Parameters:
    - Image: ${MQTT_EMQX_IMAGE}

    PostgresDB Parameters:
    - Image: ${DB_IMAGE}
    - Name: ${DB_NAME}
    - User: ${DB_USER}
    - Password: ${DB_PASSWORD}

    TradingView Bridge Parameters:
    - Image: ${TV_BRIDGE_IMAGE}
    - Security Key: ${TV_BRIDGE_SEC_KEY}
    - MQTT Topic: ${TV_BRIDGE_MQTT_TOPIC}

    Dashboard Parameters:
    - Image: ${DASHBOARD_IMAGE}
    - Port: ${DASHBOARD_PORT}
"""

docker compose -f ./compose/${COMPOSE_FILENAME} down &&     \
    docker compose -f ./compose/${COMPOSE_FILENAME}         \
    ${PROFILES}                                             \
    up --remove-orphans                                     \
    -d

