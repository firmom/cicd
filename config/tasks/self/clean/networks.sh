#!/bin/bash
set -e

#docker network rm $(docker network ls | awk '$3 == "bridge" && $2 != "bridge" { print $1 }')
docker network prune -f
