#!/bin/sh
set -e

REPO_URL="https://github.com/sebastianpozoga/events.pozoga.eu"
DIRECTORY="/go/src/github.com/sebastianpozoga/events.pozoga.eu"

if [ -d "$DIRECTORY" ]; then
  cd "$DIRECTORY"
  git reset --hard
  git clean -f -d
  git pull
fi

if [ ! -d "$DIRECTORY" ]; then
  git clone "$REPO_URL" "$DIRECTORY"
fi
