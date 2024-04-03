#!/usr/bin/env bash

set -Eeuo pipefail

# Define variables
readonly dir="$(dirname "$0")" 

jq '.[] | select(.type == "Ride" and .gear_id != "b11645909" and .gear_id != "b13729442")' activities/merged.json | \
  jq -s . | \
  jq 'map({name,start_date_local,distance})' | \
  jq 'sort_by(.start_date_local)' | \
  jq 'map(select(.start_date_local | startswith("2024")))' > activities/ride_2024.json

METERS_IN_MILE=1609.34
meters_ridden=$(jq 'map(.distance) | add' activities/ride_2024.json)
echo "$meters_ridden / $METERS_IN_MILE" | bc -l
