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
      - 3011:443
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