#!/bin/sh
set -e

REPO_URL="https://github.com/goatcms/goatcore"
DIRECTORY="/go/src/github.com/goatcms/goatcore"

if [ -d "$DIRECTORY" ]; then
  cd "$DIRECTORY"
  git reset --hard
  git clean -f -d
  git pull
fi

if [ ! -d "$DIRECTORY" ]; then
  git clone "$REPO_URL" "$DIRECTORY"
fi
