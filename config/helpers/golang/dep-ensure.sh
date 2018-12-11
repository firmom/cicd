#!/bin/bash
set -e

HOST="$1"
REPO="$2"
TAG="$3"
GOPATH="/data/code/$REPO-$TAG"
SRC_PATH="$GOPATH/src/$HOST/$REPO"

cd $SRC_PATH
if [ -f "Gopkg.toml" ]; then
  dep ensure
fi
