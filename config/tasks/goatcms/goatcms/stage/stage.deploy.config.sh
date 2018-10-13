#!/bin/sh
set -e

REPO="$1"
TAG="$2"
IMAGE="$3"
DEST_DIR_PATH="/data/docker/$REPO-$TAG"
DEST_FILE_PATH="$DEST_DIR_PATH/docker-compose.yaml"

mkdir -p $DEST_DIR_PATH

# Add config file
cat > $DEST_FILE_PATH << EndOfMessage
version: '3.4'

services:
  events:
    image: $IMAGE
    environment:
      TZ: 'Europe/Warsaw'
    restart: always
    environment:
    volumes:
      - "/dockerdata/$REPO/$TAG/uploads:/app/wp-content/uploads"
      - "/dockerdata/$REPO/$TAG/snapshots:/data/snapshots"
      - "/dockerdata/certs/firmom.com:/certs"
    ports:
      - 3011:443
  db:
    image: mariadb
    restart: always
    environment:
      - "MYSQL_DATABASE=stage.GoatCMS"
      - "MYSQL_USER=$GOATCMS_DB_USER"
      - "MYSQL_PASSWORD=$GOATCMS_DB_PASS"
      - "MYSQL_ROOT_PASSWORD=$GOATCMS_DB_PASS"
    volumes:
      - "/dockerdata/$REPO/$TAG/mysql:/var/lib/mysql"
  phpmyadmin:
    image: phpmyadmin/phpmyadmin
    restart: always
    ports:
     - 13011:80
    environment:
      - "PMA_HOST=db"
      - "PMA_VERBOSE=stage.GoatCMS"
      - "PMA_PORT=3306"
      - "PMA_ARBITRARY=1"

EndOfMessage