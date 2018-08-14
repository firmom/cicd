#!/bin/sh
set -e

cat $DOCKER_PASSWORD_FILE | docker login --username $DOCKER_USERNAME --password-stdin
docker tag firmom/cicd:latest firmom/cicd:stable
docker push firmom/cicd:stable
