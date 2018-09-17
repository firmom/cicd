#!/bin/sh
set -e

IMAGE = $1
DEST_DIR_PATH = "/data/docker/$IMAGE"
DEST_FILE_PATH = "$DEST_DIR_PATH/docker-compose.yaml"

mkdir -p $DEST_DIR_PATH

# Add config file
cat > $DEST_FILE_PATH << EndOfMessage
version: '3.4'

services:
  beerpolyhome:
    image: $IMAGE
    networks:
      - nproxy
    restart: always
    environment:
      - "TZ=Europe/Warsaw"
      # routing
      # - "VIRTUAL_HOST=beerpoly.gamein.pl"
      # App settings and secrets
      - "APP_HOST=beerpoly.gamein.pl"
      - "APP_BASE_URL=http://beerpoly.gamein.pl"
      - "OAUTH_GITHUB_APP=Insert_your_app_id"
      - "OAUTH_GITHUB_SECRET=Insert_your_app_secret"
      # Menu (those links are different on dev and production server)
      - "MENU_OPEN_SOURCE_LINK=https://github.com/gameinpl"
      - "MENU_GAME_LINK=http://cicd.firmom.com:2077/"
      - "MENU_DOWNLOAD_LINK=http://cicd.firmom.com:2079/gameinpl/beerpoly/"
      # Users
EndOfMessage


# Copy users environments
for i in `env | grep -E "^USER_"`; do
    echo "      - \"$i\"" >> $DEST_FILE_PATH
done

# Add rest of config file
cat >> $DEST_FILE_PATH << EndOfMessage
    volumes:
      - "/dockerdata/$IMAGE/data:/data"
    ports:
     - 2078:80

networks:
  nproxy:
    external:
      name: nproxy
  default:

EndOfMessage
