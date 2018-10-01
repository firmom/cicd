#!/bin/sh
set -e

REPO="$1"
TAG="$2"
FILENAME="$3"
DIR="/data/archive/$REPO/$TAG/"
BASEPATH="/data/archive/$REPO/$TAG/$FILEBASE"

mkdir -p $DIR
rm "$BASEPATH-latest"
cp "$BASEPATH $BASEPATH-latest"
cp "$BASEPATH" "$BASEPATH-$(date +%Y%m%d_%H%M%S)"
