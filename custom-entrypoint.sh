#!/bin/bash
set -e

# prepare docker password file
echo $DOCKER_PASSWORD > $DOCKER_PASSWORD_FILE

# add ssh key
eval `ssh-agent -s`
if [ -f "/root/.ssh/id_rsa" ]; then
  ssh-add /root/.ssh/id_rsa
fi

# prepare index
sed -i "s|<<APP_HOST>>|$APP_HOST|g" /staticdata/home/index.html

# Routing
mkdir -p /data/archive
cat > /app/config/routing.json << EndOfMessage
{"static":[{
  "prefix": "/static/",
  "path": "./web/dist/"
},{
  "prefix": "/archive/",
  "path": "/data/archive/"
}]}
EndOfMessage

# run base entrypoint
sh -x "/app/docker/entrypoint.sh"
