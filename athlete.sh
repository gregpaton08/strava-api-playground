#!/usr/bin/env bash

set -Eeuo pipefail

TOKEN=$(cat token.txt)
curl -X GET "https://www.strava.com/api/v3/athlete" -H "Authorization: Bearer $TOKEN" > athlete.json
