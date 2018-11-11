#!/bin/bash
set -e

SCRIPT="$1"
IMAGE="$2"
PORT_OFFSET="$3"

for i in `env | grep -E "^USER_.*_USERNAME="`; do
  key=$(echo $i| cut -d'_' -f 2)
  baseKey="USER_${key}_"
  eval username=\${${baseKey}USERNAME}
  eval user_base_port=\${${baseKey}BASE_PORT}
  if [ ! -z $user_base_port ]; then
    baseport=$(($user_base_port+$PORT_OFFSET))
    echo "RUN bash -x $SCRIPT $IMAGE $baseport $baseKey; for $username; baseport=$baseport"
    bash -x $SCRIPT $IMAGE $baseport $baseKey
  fi
done
