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

DEST_HELP_DIR_PATH="/data/deploy/_user/$name"
DEST_HELP_FILE_PATH="$DEST_HELP_DIR_PATH/README_PORTS.txt"

REMOTE_DIR_PATH="~/_user/$name"
REMOTE_FILE_PATH="$DEST_DIR_PATH/docker-compose.yaml"

REMOTE_HELP_DIR_PATH="/dockerdata/devtools/$NAME/work"
REMOTE_HELP_FILE_PATH="$DEST_HELP_DIR_PATH/README_PORTS.txt"

mkdir -p $DEST_DIR_PATH

# Prepare config file
cat > $DEST_FILE_PATH << EndOfMessage
version: '3'

## $NAME port list:
# (public port) -> (container port)
# $PORT_VNC_SYS -> 5000 (VNC system port)
# $PORT_VNC_CONN -> 5901 (VNC first desktop - use it for vnc viewer )
# $PORT_VNC_WEB -> 6901 (VNC web browser port)
# $PORT_80 -> 80 (default HTTP port)
# $PORT_8080 -> 8080 (external HTTP port)
# $PORT_3000 -> 3000 (development port)
# $PORT_SFTP -> 22 (SFTP port to share directory)
#
# Your personal data (never share):
# username: $NAME
# password: $PASSWORD

services:
  centos:
    image: $IMAGE
    ports:
     - "$PORT_VNC_SYS:5000"
     - "$PORT_VNC_CONN:5901"
     - "$PORT_VNC_WEB:6901"
     - "$PORT_80:80"
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

# Prepare help file
cat > $DEST_HELP_FILE_PATH << EndOfMessage
## $NAME port list:
# (public port) -> (container port)
# $PORT_VNC_SYS -> 5000 (VNC system port)
# $PORT_VNC_CONN -> 5901 (VNC first desktop - use it for vnc viewer )
# $PORT_VNC_WEB -> 6901 (VNC web browser port)
# $PORT_80 -> 80 (default HTTP port)
# $PORT_8080 -> 8080 (external HTTP port)
# $PORT_3000 -> 3000 (development port)
# $PORT_SFTP -> 22 (SFTP port to share directory)
EndOfMessage

# Deploy config
ssh $DEPLOY_DEVTOOLS_REMOTE_USER@$DEPLOY_DEVTOOLS_REMOTE_HOST "mkdir -p $REMOTE_DIR_PATH"
scp -o "StrictHostKeyChecking no" "$DEST_FILE_PATH" "$DEPLOY_DEVTOOLS_REMOTE_USER@$DEPLOY_DEVTOOLS_REMOTE_HOST:$REMOTE_FILE_PATH"

# Deploy help
ssh $DEPLOY_DEVTOOLS_REMOTE_USER@$DEPLOY_DEVTOOLS_REMOTE_HOST "mkdir -p $REMOTE_HELP_DIR_PATH"
scp -o "StrictHostKeyChecking no" "$DEST_HELP_FILE_PATH" "$DEPLOY_DEVTOOLS_REMOTE_USER@$DEPLOY_DEVTOOLS_REMOTE_HOST:$REMOTE_HELP_FILE_PATH"

# Append app
ssh -o "StrictHostKeyChecking no" $DEPLOY_DEVTOOLS_REMOTE_USER@$DEPLOY_DEVTOOLS_REMOTE_HOST << ENDSSH
#commands to run on remote host
set -e

docker pull $IMAGE
cd $REMOTE_DIR_PATH
docker-compose rm --force --stop -v
docker-compose up -d

ENDSSH
