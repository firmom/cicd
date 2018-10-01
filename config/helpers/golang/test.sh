#!/bin/bash
set -e

HOST="$1"
REPO="$2"
TAG="$3"
TEST_PATH="$4"
GOPATH="/data/code/$REPO-$TAG"
SRC_PATH="$GOPATH/src/$HOST/$REPO"

cd $SRC_PATH
go test $TEST_PATH
