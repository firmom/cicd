#!/bin/sh
set -e

REPO="$1"
TAG="$2"
DOMAIN="$3"
SRC="/etc/letsencrypt/live/$DOMAIN/."
DEST="/dockerdata/$REPO/$TAG/certs/$DOMAIN/"

# Deploy certs
ssh $DEPLOY_DEV_REMOTE_USER@$DEPLOY_DEV_REMOTE_HOST "mkdir -p $DEST"
scp -rp -o "StrictHostKeyChecking no" "$SRC" "$DEPLOY_DEV_REMOTE_USER@$DEPLOY_DEV_REMOTE_HOST:$DEST"
