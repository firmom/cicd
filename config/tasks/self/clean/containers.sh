#!/bin/bash
set -e

# see: http://stackoverflow.com/questions/32723111/how-to-remove-old-and-unused-docker-images
docker rm $(docker ps -qa --no-trunc --filter "status=exited")
