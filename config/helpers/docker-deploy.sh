#!/bin/sh
set -e

IMAGE="$1"

# Deploy config
ssh $DEPLOY_DEV_REMOTE_USER@$DEPLOY_DEV_REMOTE_HOST "mkdir -p ~/$IMAGE/"
scp -o "StrictHostKeyChecking no" /data/docker/$IMAGE/docker-compose.yaml $DEPLOY_DEV_REMOTE_USER@$DEPLOY_DEV_REMOTE_HOST:~/$IMAGE/docker-compose.yaml

# Deploy App
ssh -o "StrictHostKeyChecking no" $DEPLOY_DEV_REMOTE_USER@$DEPLOY_DEV_REMOTE_HOST << ENDSSH
#commands to run on remote host
set -e

docker pull $IMAGE
cd ~/$IMAGE
docker-compose rm --force --stop -v
docker-compose up -d

ENDSSH
