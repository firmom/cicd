#!/bin/sh
set -e

HOST="$1"
REPO="$2"
BRANCH="$3"
TAG="$4"
DIRECTORY="/data/code/$REPO-$TAG"
GIT_REPO="https://$HOST/$REPO.git"

if [ -d "$DIRECTORY" ]; then
  cd "$DIRECTORY"
  git fetch --all
  git reset --hard origin/$BRANCH
  git pull
fi

if [ ! -d "$DIRECTORY" ]; then
  git clone -b "$BRANCH" "$GIT_REPO" "$DIRECTORY"
fi
