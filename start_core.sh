#!/usr/bin/env bash

docker compose -f core.compose.yml down && \
    docker compose -f core.compose.yml up --remove-orphans
