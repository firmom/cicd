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
    restart: always
    networks:
      - nproxy
      - default
    environment:
      TZ: 'Europe/Warsaw'
    environment:
      - "MODE=SSL"
      - "DOMAIN=events.pozoga.eu"
      - "VIRTUAL_HOST=events.pozoga.eu"
      - "VIRTUAL_PROTO=https"
      - "VIRTUAL_PORT=443"
      - "DB_HOST=db"
      - "DB_PORT=3306"
      - "DB_NAME=prod.events.pozoga.eu"
      - "DB_USER=$EVENTS_POZOGA_EU_DB_USER"
      - "DB_PASS=$EVENTS_POZOGA_EU_DB_PASS"
      - "WP_USER=$EVENTS_POZOGA_EU_WP_USER_NAME"
      - "WP_PASS=$EVENTS_POZOGA_EU_WP_USER_PASS"
      - "WP_EMAIL=$EVENTS_POZOGA_EU_WP_USER_EMAIL"
      - "WP_HOST=events.pozoga.eu"
      - "WP_TITLE=Events Poznań"
    volumes:
      - "/dockerdata/sebastianpozoga/events.pozoga.eu/prod/uploads:/app/wp-content/uploads"
      - "/dockerdata/$REPO/$TAG/certs/pozoga.eu:/certs"
    expose:
      - 80
      - 443
  db:
    image: mariadb
    restart: always
    networks:
      - default
    environment:
      - "MYSQL_DATABASE=prod.events.pozoga.eu"
      - "MYSQL_USER=$EVENTS_POZOGA_EU_DB_USER"
      - "MYSQL_PASSWORD=$EVENTS_POZOGA_EU_DB_PASS"
      - "MYSQL_ROOT_PASSWORD=$EVENTS_POZOGA_EU_DB_PASS"
    volumes:
      - "/dockerdata/sebastianpozoga/events.pozoga.eu/prod/mysql:/var/lib/mysql"
  phpmyadmin:
    image: phpmyadmin/phpmyadmin
    restart: always
    networks:
      - default
    ports:
     - 2014:80
    environment:
      - "PMA_HOST=db"
      - "PMA_VERBOSE=prod.events.pozoga.eu"
      - "PMA_PORT=3306"
      - "PMA_ARBITRARY=1"

networks:
  nproxy:
    external:
      name: nproxy
  default:

EndOfMessage
