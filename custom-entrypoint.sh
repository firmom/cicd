#!/bin/bash
set -e

export DOCKER_PASSWORD_FILE="/docker-password"

echo $DOCKER_PASSWORD > $DOCKER_PASSWORD_FILE

sh -x "/go/src/github.com/goatcms/webslots/docker/entrypoint.sh"
