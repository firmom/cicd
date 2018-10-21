#!/bin/sh
set -e
ACCESS="$1"

cat > ~/.npmrc << EndOfMessage
//registry.npmjs.org/:_authToken=$NPM_TOKEN
EndOfMessage

PACKAGE_NAME=$(cat package.json \
  | grep name \
  | head -1 \
  | awk -F: '{ print $2 }' \
  | sed 's/[",]//g' \
  | tr -d '[[:space:]]')

LATEST_VERSION=$(npm show $PACKAGE_NAME version)

npm version --no-git-tag-version --allow-same-version $LATEST_VERSION
npm version patch --no-git-tag-version

npm publish --access $ACCESS
