#!/bin/sh
set -e

ACCESS="$1"

cat > ~/.npmrc << EndOfMessage
//registry.npmjs.org/:_authToken=$NPM_TOKEN
EndOfMessage

npm version patch --no-git-tag-version
npm publish --access $ACCESS
