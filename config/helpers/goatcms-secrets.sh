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
    "address": "smtp.gmail.com:465",
    "user": "$SMTP_USERNAME",
    "password": $SMTP_PASSWRD",
    "identity": ""
  },
  "oauth": {
    "github": {
      "app": "",
      "secret": ""
    }
  }
}
EndOfMessage
