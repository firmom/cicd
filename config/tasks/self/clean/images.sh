#!/bin/bash
set -e

# see: http://stackoverflow.com/questions/32723111/how-to-remove-old-and-unused-docker-images
docker rmi $(docker images --filter "dangling=true" -q --no-trunc)
docker rmi $(docker images | grep "none" | awk '/ / { print $3 }')
