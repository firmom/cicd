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
      - "/dockerdata/certs/gamein.pl:/certs"
    ports:
      - 4077:443
  db:
    image: mariadb
    restart: always
    environment:
      - "MYSQL_DATABASE=prod.Beerpoly"
      - "MYSQL_USER=$BEERPOLY_DB_USER"
      - "MYSQL_PASSWORD=$BEERPOLY_DB_PASS"
      - "MYSQL_ROOT_PASSWORD=$BEERPOLY_DB_PASS"
    volumes:
      - "/dockerdata/$REPO/$TAG/mysql:/var/lib/mysql"
  phpmyadmin:
    image: phpmyadmin/phpmyadmin
    restart: always
    ports:
     - 14077:80
    environment:
      - "PMA_HOST=db"
      - "PMA_VERBOSE=prod.Beerpoly"
      - "PMA_PORT=3306"
      - "PMA_ARBITRARY=1"

EndOfMessage