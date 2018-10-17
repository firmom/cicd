#!/bin/sh
set -e

REPO="$1"
TAG="$2"
IMAGE="$3"
DEST_DIR_PATH="/data/deploy/$REPO-$TAG"
DEST_FILE_PATH="$DEST_DIR_PATH/docker-compose.yaml"

mkdir -p $DEST_DIR_PATH

# Add config file
cat > $DEST_FILE_PATH << EndOfMessage
version: '3.4'

services:
  main:
    image: $IMAGE
    environment:
      - "TZ=Europe/Warsaw"
      - "MODE=HTTPS"
    restart: always
    volumes:
      - "/dockerdata/$REPO-$TAG/data:/app/data"
      - "/dockerdata/certs/firmom.com:/certs"
    ports:
      - 2333:443


EndOfMessage