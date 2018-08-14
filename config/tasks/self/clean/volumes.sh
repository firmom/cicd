#!/bin/bash
set -e

# see: https://github.com/chadoe/docker-cleanup-volumes
# docker volume ls -qf dangling=true | xargs -r docker volume rm
# WARNING: remove volumes can be unsafe
