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
      - "DOMAIN=cicd.firmom.com:3012"
      - "DB_HOST=db"
      - "DB_PORT=3306"
      - "DB_NAME=stage.EventsPozogaEu"
      - "DB_USER=$EVENTSPOZOGAEU_DB_USER"
      - "DB_PASS=$EVENTSPOZOGAEU_DB_PASS"
      - "WP_USER=$EVENTSPOZOGAEU_WP_USER_NAME"
      - "WP_PASS=$EVENTSPOZOGAEU_WP_USER_PASS"
      - "WP_EMAIL=$EVENTSPOZOGAEU_WP_USER_EMAIL"
      - "WP_HOST=$DEPLOY_DEV_REMOTE_HOST:3012"
      - "WP_TITLE=Events Poznań"
      - "MIGRATE_FROM=events.pozoga.eu"
      - "MIGRATE_TO=cicd.firmom.com:3012"
      - "DB_SNAPSHOT=$EVENTSPOZOGAEU_DB_SNAPSHOT"
EndOfMessage

### Add users
for i in `env | grep -E "^USER_.*_USERNAME="`; do
key=$(echo $i| cut -d'_' -f 2)
baseKey="USER_${key}_"
eval username=\${${baseKey}USERNAME}
eval firstname=\${${baseKey}FIRSTNAME}
eval lastname=\${${baseKey}LASTNAME}
eval email=\${${baseKey}EMAIL}
eval roles=\${${baseKey}ROLSE}
eval password=\${${baseKey}PASSWORD}
eval github=\${${baseKey}_CONNECT_GITHUB}

cat >> $DEST_FILE_PATH << EndOfMessage
      - "USER_${i}_USERNAME=${username}"
      - "USER_${i}_FIRSTNAME=${firstname}"
      - "USER_${i}_LASTNAME=${lastname}"
      - "USER_${i}_EMAIL=${email}"
      - "USER_${i}_ROLES=${roles}"
      - "USER_${i}_PASSWORD=${password}"
      - "USER_${i}_CONNECT_GITHUB=${github}"
EndOfMessage
done
cat >> $DEST_FILE_PATH << EndOfMessage
    volumes:
      - "/dockerdata/$REPO-$TAG/uploads:/app/wp-content/uploads"
      - "/dockerdata/$REPO-$TAG/snapshots:/data/snapshots"
      - "/dockerdata/certs/firmom.com:/certs"
    ports:
      - 3012:443
  db:
    image: mariadb
    restart: always
    environment:
      - "MYSQL_DATABASE=stage.EventsPozogaEu"
      - "MYSQL_USER=$EVENTSPOZOGAEU_DB_USER"
      - "MYSQL_PASSWORD=$EVENTSPOZOGAEU_DB_PASS"
      - "MYSQL_ROOT_PASSWORD=$EVENTSPOZOGAEU_DB_PASS"
    volumes:
      - "/dockerdata/$REPO-$TAG/mysql:/var/lib/mysql"
  phpmyadmin:
    image: phpmyadmin/phpmyadmin
    restart: always
    ports:
     - 13012:80
    environment:
      - "PMA_HOST=db"
      - "PMA_VERBOSE=stage.EventsPozogaEu"
      - "PMA_PORT=3306"
      - "PMA_ARBITRARY=1"

EndOfMessage