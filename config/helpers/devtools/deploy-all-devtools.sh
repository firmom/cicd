#!/bin/bash
set -e

IMAGE="$1"
PORT_OFFSET="$2"

for i in `env | grep -E "^USER_.*_USERNAME="`; do
  key=$(echo $i| cut -d'_' -f 2)
  baseKey="USER_${key}_"
  eval username=\${${baseKey}USERNAME}
  eval firstname=\${${baseKey}FIRSTNAME}
  eval lastname=\${${baseKey}LASTNAME}
  eval email=\${${baseKey}EMAIL}
  eval roles=\${${baseKey}ROLSE}
  eval password=\${${baseKey}PASSWORD}
  eval github=\${${baseKey}CONNECT_GITHUB}
  eval user_base_port=\${${baseKey}BASE_PORT}
  eval vnc_resolution=\${${baseKey}VNC_RESOLUTION}
  eval vnc_col_depth=\${${baseKey}VNC_COL_DEPTH}

  if [[ ! -z $user_base_port && ! -z $PORT_OFFSET ]]; then
    baseport=$(($user_base_port + $PORT_OFFSET))
    /app/config/helpers/devtools/deploy-single-devtools.sh $IMAGE $username $password $vnc_resolution $vnc_col_depth $email $firstname $lastname $base_port
  fi
done
