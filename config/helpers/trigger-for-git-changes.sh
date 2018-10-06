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
    curl -X POST "https://localhost/api/task/$TASK/$API_SECRET"
  fi
fi

if [ ! -d "$DIRECTORY" ]; then
  echo "$DIRECTORY doesn't exists - trigger to pull"
  curl -X POST "https://localhost/api/task/$TASK/$API_SECRET"
fi
