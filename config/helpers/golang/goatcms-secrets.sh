#!/bin/bash
set -e

HOST="$1"
REPO="$2"
TAG="$3"
SECRETS_PATH="/data/code/$REPO-$TAG/src/$HOST/$REPO/.goat/secrets.json"

cat > $SECRETS_PATH << EndOfMessage
{
  "database": {
    "engine": "sqlite",
    "host": "",
    "name": "",
    "password": "",
    "username": ""
  },
  "smtp": {
    "address": "",
    "identity": "",
    "password": "",
    "user": ""
  },
  "oauth": {
    "github": {
      "app": "",
      "secret": ""
    }
  }
}
EndOfMessage
