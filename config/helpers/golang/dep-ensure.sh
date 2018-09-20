#!/bin/bash
set -e

HOST="$1"
REPO="$2"
TAG="$3"
GOPATH="/data/code/$REPO-$TAG"
SRC_PATH="/data/code/$REPO-$TAG/src/$HOST/$REPO"

cd $SRC_PATH
rm -rf vendor
dep ensure
