#!/bin/bash
set -e

cat > /go/src/github.com/goatcms/goatcms/.goat/secrets.json << EndOfMessage
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
