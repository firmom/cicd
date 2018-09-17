#!/bin/sh
set -e

REPO_URL="$1"
BRANCH="$2"
IMAGE="$3"
DIRECTORY="/data/code/$IMAGE"

if [ -d "$DIRECTORY" ]; then
  cd "$DIRECTORY"
  git fetch --all
  git reset --hard origin/$BRANCH
  git pull
fi

if [ ! -d "$DIRECTORY" ]; then
  git clone -b "$BRANCH" "$REPO_URL" "$DIRECTORY"
fi
