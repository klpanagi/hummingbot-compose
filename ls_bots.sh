#!/usr/bin/env bash

CONTAINER_PREFIX="hbot-"

help()
{
    echo "Usage: ./ls_bots.sh [ -h | --help ]"
    exit 2
}

SHORT=h
LONG=help
OPTS=$(getopt -a -n ls_bots.sh --options $SHORT --longoptions $LONG -- "$@")

VALID_ARGUMENTS=$# # Returns the count of arguments that are in short or long options

eval set -- "$OPTS"

while :
do
  case "$1" in
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


echo 'Bots at [Exited] state'
echo '----------------------'
docker container ls -a --format 'table {{.Names}}\t{{.Status}}' -f 'status=exited' | grep ${CONTAINER_PREFIX}
echo '----------------------'
echo
echo 'Bots at [Running] state'
echo '-----------------------'
docker container ls -a --format 'table {{.Names}}\t{{.Status}}' -f 'status=running' | grep ${CONTAINER_PREFIX}
echo '-----------------------'
