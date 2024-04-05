#!/usr/bin/env bash

set -Eeuo pipefail

RESULT=$(curl -X POST https://www.strava.com/api/v3/oauth/token \
  -d client_id=$(cat client_id) \
  -d client_secret=$(cat client_secret) \
  -d grant_type=refresh_token \
  -d refresh_token=$(cat refresh_token))

TOKEN=$(echo $RESULT | sed -n 's/.*"access_token":"\([^"]*\).*/\1/p')

CURRENT_TOKEN=$(cat access_token)

if [ "$TOKEN" != "$CURRENT_TOKEN" ]; then
  mv access_token access_token.bak
  echo $TOKEN > access_token
  echo "updated token"
else
  echo "token is already up to date"
fi
