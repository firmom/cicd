#!/bin/sh
set -e

mkdir -p /data/docker/sebastianpozoga/events.pozoga.eu-prod

cat > /data/docker/sebastianpozoga/events.pozoga.eu-prod/docker-compose.yaml << EndOfMessage
version: '3.4'

services:
  events:
    image: spozoga/events.pozoga.eu
    restart: always
    networks:
      - nproxy
      - default
    environment:
      TZ: 'Europe/Warsaw'
    environment:
      - "VIRTUAL_HOST=events.pozoga.eu"
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
    expose:
      - 80
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

ssh $DEPLOY_DEV_REMOTE_USER@$DEPLOY_DEV_REMOTE_HOST 'mkdir -p ~/sebastianpozoga/events.pozoga.eu-prod/'
scp -o "StrictHostKeyChecking no" /data/docker/sebastianpozoga/events.pozoga.eu-prod/docker-compose.yaml $DEPLOY_DEV_REMOTE_USER@$DEPLOY_DEV_REMOTE_HOST:~/sebastianpozoga/events.pozoga.eu-prod/docker-compose.yaml
