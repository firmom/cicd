#!/bin/bash
set -e

IMAGE="$1"
SECRETS_PATH="/go/src/github/$IMAGE/.goat/secrets.json"

cat > $SECRETS_PATH << EndOfMessage
{
  "database": {
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