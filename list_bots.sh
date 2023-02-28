#!/usr/bin/env bash

docker container ls -a --format 'table {{.Names}}\t{{.State}}\t{{.Status}}' | grep hbot
