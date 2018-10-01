#!/bin/sh
set -e

REPO="$1"
TAG="$2"
IMAGE="$REPO:$TAG"
DEST_DIR_PATH="/data/docker/$REPO-$TAG"
DEST_FILE_PATH="$DEST_DIR_PATH/docker-compose.yaml"

mkdir -p $DEST_DIR_PATH

# Add config file
cat > $DEST_FILE_PATH << EndOfMessage
version: '3.4'

services:
  goatcms:
    image: $IMAGE
    networks:
      - nproxy
    restart: always
    environment:
      - "TZ=Europe/Warsaw"
      # routing
      - "SECURITY_MODE=TLS"
      # - "VIRTUAL_HOST=goatcms.org"
      # App settings and secrets
      - "APP_HOST=goatcms.org"
      - "APP_BASE_URL=https://goatcms.org"
      - "OAUTH_GITHUB_APP=Insert_your_app_id"
      - "OAUTH_GITHUB_SECRET=Insert_your_app_secret"
      # Users
EndOfMessage


# Copy users environments
for i in `env | grep -E "^USER_"`; do
    echo "      - \"$i\"" >> $DEST_FILE_PATH
done

# Add rest of config file
cat >> $DEST_FILE_PATH << EndOfMessage
    volumes:
      - "/dockerdata/$REPO-$TAG/data:/data"
      - "/dockerdata/$REPO/$TAG/certs/firmom.com:/certs"
    ports:
     - 2011:80

networks:
  nproxy:
    external:
      name: nproxy
  default:

EndOfMessage
