#!/bin/sh
set -e

REPO_URL="https://github.com/goatcms/goatcli"
DIRECTORY="/go/src/github.com/goatcms/goatcli"

if [ -d "$DIRECTORY" ]; then
  cd "$DIRECTORY"
  git fetch --all
  git reset --hard origin/master
  git pull
fi

if [ ! -d "$DIRECTORY" ]; then
  git clone "$REPO_URL" "$DIRECTORY"
fi
