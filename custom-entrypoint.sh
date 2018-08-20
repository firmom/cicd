#!/bin/bash
set -e

# prepare docker password file
echo $DOCKER_PASSWORD > $DOCKER_PASSWORD_FILE

# add ssh key
if [ -f "/root/.ssh/id_rsa" ]; then
  ssh-add /root/.ssh/id_rsa
fi

# prepare index
sed -i "s|<<APP_HOST>>|$APP_HOST|g" /staticdata/home/index.html

# run static files serve
mkdir -p /data/serve/gameinpl/beerpoly
mkdir -p /data/serve/gameinpl/beerpoly-home
mkdir -p /data/archive

ran -p=80 -r=/staticdata/home -l=true &
ran -p=2077 -r=/data/serve/gameinpl/beerpoly -l=true &
ran -p=2078 -r=/data/serve/gameinpl/beerpoly-home -l=true &
ran -p=2079 -r=/data/archive -l=true &

# run cron
cron &

# run base entrypoint
sh -x "/app/docker/entrypoint.sh"
