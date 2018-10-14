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
  events:
    image: $IMAGE
    environment:
      TZ: 'Europe/Warsaw'
    restart: always
    environment:
      - "MODE=SSL"
      - "DOMAIN=events.pozoga.eu:4011"
      - "DB_HOST=db"
      - "DB_PORT=3306"
      - "DB_NAME=prod.EventsPozogaEu"
      - "DB_USER=$EVENTSPOZOGAEU_DB_USER"
      - "DB_PASS=$EVENTSPOZOGAEU_DB_PASS"
      - "WP_USER=$EVENTSPOZOGAEU_WP_USER_NAME"
      - "WP_PASS=$EVENTSPOZOGAEU_WP_USER_PASS"
      - "WP_EMAIL=$EVENTSPOZOGAEU_WP_USER_EMAIL"
      - "WP_HOST=$DEPLOY_DEV_REMOTE_HOST:4011"
      - "WP_TITLE=Events Poznań"
    volumes:
      - "/dockerdata/$REPO/$TAG/uploads:/app/wp-content/uploads"
      - "/dockerdata/$REPO/$TAG/snapshots:/data/snapshots"
      - "/dockerdata/certs/pozoga.eu:/certs"
    ports:
      - 4011:443
  db:
    image: mariadb
    restart: always
    environment:
      - "MYSQL_DATABASE=prod.EventsPozogaEu"
      - "MYSQL_USER=$EVENTSPOZOGAEU_DB_USER"
      - "MYSQL_PASSWORD=$EVENTSPOZOGAEU_DB_PASS"
      - "MYSQL_ROOT_PASSWORD=$EVENTSPOZOGAEU_DB_PASS"
    volumes:
      - "/dockerdata/$REPO/$TAG/mysql:/var/lib/mysql"
  phpmyadmin:
    image: phpmyadmin/phpmyadmin
    restart: always
    ports:
     - 14011:80
    environment:
      - "PMA_HOST=db"
      - "PMA_VERBOSE=prod.EventsPozogaEu"
      - "PMA_PORT=3306"
      - "PMA_ARBITRARY=1"

EndOfMessage