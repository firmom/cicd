#!/bin/sh
set -e

cat $DOCKER_PASSWORD_FILE | docker login --username $DOCKER_USERNAME --password-stdin
docker push firmom/centos-devtools
