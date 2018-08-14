#!/bin/bash
set -e

# see: https://github.com/chadoe/docker-cleanup-volumes
docker volume rm $(docker volume ls -qf dangling=true)
docker volume ls -qf dangling=true | xargs -r docker volume rm
