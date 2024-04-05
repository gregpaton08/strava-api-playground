#!/usr/bin/env bash

set -Eeuo pipefail

TOKEN=$(cat access_token)
curl -X GET "https://www.strava.com/api/v3/athlete" -H "Authorization: Bearer $TOKEN" > athlete.json
