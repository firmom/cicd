#!/bin/sh
set -e

REPO_URL="https://github.com/firmom/firmom-cicd"
DIRECTORY="data/code/firmomcicd"

if [ -d "$DIRECTORY" ]; then
  cd "$DIRECTORY"
  git reset --hard
  git clean -f -d
  git pull
fi

if [ ! -d "$DIRECTORY" ]; then
  git clone "$REPO_URL" "$DIRECTORY"
fi
