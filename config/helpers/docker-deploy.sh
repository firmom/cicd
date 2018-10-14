#!/bin/sh
set -e

REPO="$1"
TAG="$2"
IMAGE="$3"

# Deploy config
ssh $DEPLOY_DEV_REMOTE_USER@$DEPLOY_DEV_REMOTE_HOST "mkdir -p ~/deploy/$REPO-$TAG/"
scp -o "StrictHostKeyChecking no" "/data/deploy/$REPO-$TAG/docker-compose.yaml" "$DEPLOY_DEV_REMOTE_USER@$DEPLOY_DEV_REMOTE_HOST:~/deploy/$REPO-$TAG/docker-compose.yaml"

# Deploy App
ssh -o "StrictHostKeyChecking no" $DEPLOY_DEV_REMOTE_USER@$DEPLOY_DEV_REMOTE_HOST << ENDSSH
#commands to run on remote host
set -e

docker pull $IMAGE
cd ~/deploy/$REPO-$TAG
docker-compose rm --force --stop -v
docker-compose up -d

ENDSSH
