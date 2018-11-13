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
    restart: always
    volumes:
      - "/dockerdata/$REPO-$TAG/data:/app/data"
      - "/dockerdata/certs/firmom.com:/certs"
    ports:
      - 4333:443
    environment:
      - "TZ=Europe/Warsaw"
      - "MODE=HTTPS"
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
eval github=\${${baseKey}CONNECT_GITHUB}

cat >> $DEST_FILE_PATH << EndOfMessage
      - "USER_${key}_USERNAME=${username}"
      - "USER_${key}_FIRSTNAME=${firstname}"
      - "USER_${key}_LASTNAME=${lastname}"
      - "USER_${key}_EMAIL=${email}"
      - "USER_${key}_ROLES=${roles}"
      - "USER_${key}_PASSWORD=${password}"
      - "USER_${key}_CONNECT_GITHUB=${github}"
EndOfMessage

done