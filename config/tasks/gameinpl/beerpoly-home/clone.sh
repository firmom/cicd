#!/bin/sh
set -e

REPO_URL="https://github.com/gameinpl/beerpoly-home"
DIRECTORY="/data/code/gameinpl/beerpoly-home"

if [ -d "$DIRECTORY" ]; then
  cd "$DIRECTORY"
  git fetch --all
  git reset --hard origin/master
  git pull
fi

if [ ! -d "$DIRECTORY" ]; then
  git clone "$REPO_URL" "$DIRECTORY"
fi
