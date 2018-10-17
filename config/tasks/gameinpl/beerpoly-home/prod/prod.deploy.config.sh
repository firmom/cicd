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
      TZ: 'Europe/Warsaw'
    restart: always
    environment:
      - "MENU_OPEN_SOURCE_LINK=https://github.com/gameinpl"
      - "MENU_GAME_LINK=https://beerpoly.gamein.pl/"
      - "MENU_DOWNLOAD_LINK=https://cicd.firmom.com/archive/gameinpl/beerpoly/"
    volumes:
      - "/dockerdata/$REPO-$TAG/data:/app/data"
      - "/dockerdata/certs/gamein.pl:/certs"
    ports:
      - 4078:443
  db:
    image: mariadb
    restart: always
    environment:
      - "MYSQL_DATABASE=prod.BeerpolyHome"
      - "MYSQL_USER=$BEERPOLYHOME_DB_USER"
      - "MYSQL_PASSWORD=$BEERPOLYHOME_DB_PASS"
      - "MYSQL_ROOT_PASSWORD=$BEERPOLYHOME_DB_PASS"
    volumes:
      - "/dockerdata/$REPO-$TAG/mysql:/var/lib/mysql"
  phpmyadmin:
    image: phpmyadmin/phpmyadmin
    restart: always
    ports:
     - 14078:80
    environment:
      - "PMA_HOST=db"
      - "PMA_VERBOSE=prod.BeerpolyHome"
      - "PMA_PORT=3306"
      - "PMA_ARBITRARY=1"

EndOfMessage
