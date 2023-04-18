#!/usr/bin/env bash

CONTAINER_PREFIX="hbot-"

echo 'Bots at [Exited] state'
echo '----------------------'
docker container ls -a --format 'table {{.Names}}\t{{.Status}}' -f 'status=exited' | grep ${CONTAINER_PREFIX}
echo '----------------------'
echo
echo 'Bots at [Running] state'
echo '-----------------------'
docker container ls -a --format 'table {{.Names}}\t{{.Status}}' -f 'status=running' | grep ${CONTAINER_PREFIX}
echo '-----------------------'
