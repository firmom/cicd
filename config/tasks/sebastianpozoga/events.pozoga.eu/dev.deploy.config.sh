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
      - "MODE=SSL"
      - "DOMAIN=firmom.com:2012"
      - "DB_HOST=db"
      - "DB_PORT=3306"
      - "DB_NAME=dev.events.pozoga.eu"
      - "DB_USER=$EVENTS_POZOGA_EU_DB_USER"
      - "DB_SNAPSHOT=$EVENTS_POZOGA_EU_DB_SNAPSHOT"
      - "DB_PASS=$EVENTS_POZOGA_EU_DB_PASS"
      - "WP_USER=$EVENTS_POZOGA_EU_WP_USER_NAME"
      - "WP_PASS=$EVENTS_POZOGA_EU_WP_USER_PASS"
      - "WP_EMAIL=$EVENTS_POZOGA_EU_WP_USER_EMAIL"
      - "WP_HOST=$DEPLOY_DEV_REMOTE_HOST:2012"
      - "WP_TITLE=Events Poznań"
      - "MIGRATE_FROM=http://events.pozoga.eu"
      - "MIGRATE_TO=http://$DEPLOY_DEV_REMOTE_HOST:2012"
    volumes:
      - "/dockerdata/$REPO/$TAG/uploads:/app/wp-content/uploads"
      - "/dockerdata/$REPO/$TAG/snapshots:/data/snapshots"
      - "/dockerdata/$REPO/$TAG/firmom.com/certs:/certs"
    ports:
      - 2012:443
  db:
    image: mariadb
    restart: always
    environment:
      - "MYSQL_DATABASE=dev.events.pozoga.eu"
      - "MYSQL_USER=$EVENTS_POZOGA_EU_DB_USER"
      - "MYSQL_PASSWORD=$EVENTS_POZOGA_EU_DB_PASS"
      - "MYSQL_ROOT_PASSWORD=$EVENTS_POZOGA_EU_DB_PASS"
    volumes:
      - "/dockerdata/$REPO/$TAG/mysql:/var/lib/mysql"
  phpmyadmin:
    image: phpmyadmin/phpmyadmin
    restart: always
    ports:
     - 2013:80
    environment:
      - "PMA_HOST=db"
      - "PMA_VERBOSE=dev.events.pozoga.eu"
      - "PMA_PORT=3306"
      - "PMA_ARBITRARY=1"

EndOfMessage
