#!/bin/bash
set -e

# prepare docker password file
export DOCKER_PASSWORD_FILE="/docker-password"
echo $DOCKER_PASSWORD > $DOCKER_PASSWORD_FILE

# prepare index
sed -i "s|<<APP_HOST>>|$APP_HOST|g" staticdata/home/index.html

# run static files serve
mkdir -p data/serve/gameinpl/beerpoly
mkdir -p data/serve/gameinpl/beerpoly-home
mkdir -p data/archive

ran -p=80 -r=staticdata/home -l=true &
ran -p=2077 -r=data/serve/gameinpl/beerpoly -l=true &
ran -p=2078 -r=data/serve/gameinpl/beerpoly-home -l=true &
ran -p=2079 -r=data/archive -l=true &

# run base entrypoint
sh -x "/go/src/github.com/goatcms/webslots/docker/entrypoint.sh"