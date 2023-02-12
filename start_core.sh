#!/usr/bin/env bash

export HOST_DOCKER=/var/run/docker.sock

docker compose -f core.compose.yml down && \
    docker compose -f core.compose.yml up --remove-orphans
