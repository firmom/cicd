#!/bin/bash
set -e

REPO="$1"
TAG="$2"
TASK="$3"
DIRECTORY="/data/code/$REPO-$TAG"

if [ -d "$DIRECTORY" ]; then
  cd $DIRECTORY
  git fetch
  if [ $(git rev-parse HEAD) == $(git rev-parse @{u}) ]; then
    echo "$DIRECTORY no changes"
  else
    echo "$DIRECTORY changed"
    # Set silent mode. API_SECRET musn't be logged.
    set +x
    curl --insecure -X POST "https://localhost/api/task/$TASK/$API_SECRET"
    set -x
  fi
fi

if [ ! -d "$DIRECTORY" ]; then
  echo "$DIRECTORY doesn't exists - trigger to pull"
  # Set silent mode. API_SECRET musn't be logged.
  set +x
  curl --insecure -X POST "https://localhost/api/task/$TASK/$API_SECRET" &>/dev/null
  set -x
fi
