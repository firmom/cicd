#!/bin/sh
set -e

ssh -o "StrictHostKeyChecking no" $DEPLOY_DEV_REMOTE_USER@$DEPLOY_DEV_REMOTE_HOST <<'ENDSSH'
#commands to run on remote host
set -e

cd ~/sebastianpozoga/events.pozoga.eu
docker-compose rm --force --stop -v
docker-compose up -d

ENDSSH
