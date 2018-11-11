#!/bin/bash
set -e

IMAGE="$1"
NAME="$2"
PASSWORD="$3"
VNC_RESOLUTION="$4"
VNC_COL_DEPTH="$5"
EMAIL="$6"
FIRSTNAME="$7"
LASTNAME="$8"
BASE_PORT="$9"

PORT_VNC_SYS=$(($BASE_PORT + 0))
PORT_VNC_CONN=$(($BASE_PORT + 1))
PORT_VNC_WEB=$(($BASE_PORT + 2))
PORT_80=$(($BASE_PORT + 3))
PORT_8080=$(($BASE_PORT + 4))
PORT_3000=$(($BASE_PORT + 5))
PORT_SFTP=$(($BASE_PORT + 6))

DEST_DIR_PATH="/data/deploy/_user/$name"
DEST_FILE_PATH="$DEST_DIR_PATH/docker-compose.yaml"

mkdir -p $DEST_DIR_PATH

# Add config file
cat > $DEST_FILE_PATH << EndOfMessage
version: '3'

services:
  centos:
    image: $IMAGE
    ports:
     - "$PORT_VNC_SYS:5000"
     - "$PORT_VNC_CONN:5901"
     - "$PORT_VNC_WEB:6901"
     - "$PORT_80:3000"
     - "$PORT_8080:8080"
     - "$PORT_3000:3000"
    volumes:
     - "/dockerdata/devtools/$NAME/share:/headless/Desktop/share"
     - "/dockerdata/devtools/$NAME/work:/headless/Desktop/work"
     - "/dockerdata/devtools/$NAME/atom:/headless/.atom"
     - "/dockerdata/devtools/$NAME/www:/var/www"
     - "/dockerdata/devtools/$NAME/fssh:/headless/.ssh"
    environment:
     - "VNC_RESOLUTION=$VNC_RESOLUTION"
     - "VNC_COL_DEPTH=$VNC_COL_DEPTH"
     - "VNC_PW=$PASSWORD"
     - "GIT_USER_EMAIL=$EMAIL"
     - "GIT_USER_NAME=$FIRSTNAME $LASTNAME"
  sftp:
    image: atmoz/sftp
    volumes:
     - "/dockerdata/devtools/$NAME/share:/home/$NAME/share"
    ports:
     - "$PORT_SFTP:22"
    command: "$NAME:$PASSWORD"

EndOfMessage

cd $DEST_DIR_PATH
docker-compose rm --force --stop -v
docker-compose up -d
