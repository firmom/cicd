#!/bin/bash
set -e

### Add random variables
if [[ ! $API_SECRET ]]; then
  export API_SECRET=$(openssl rand -hex 36)
  echo "Generated API_SECRET=$API_SECRET"
fi
mkdir -p /secrets
echo $API_SECRET > /secrets/api

# prepare docker password file
echo $DOCKER_PASSWORD > $DOCKER_PASSWORD_FILE

# add ssh key
eval `ssh-agent -s`
if [ -f "/root/.ssh/id_rsa" ]; then
  ssh-add /root/.ssh/id_rsa
fi

# link data directory
if [ ! -d /app/data ]; then
  ln -s /data /app/data
fi

# prepare config
/bin/bash -x /app/docker/config.sh

# prepare routing
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

# load default data like fragments
./webslots db:fixtures:load --path=fixtures ||:

### run app
./webslots run --loglvl=$LOGLVL
