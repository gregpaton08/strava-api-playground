#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
if [[ "${TRACE-0}" == "1" ]]; then
    set -o xtrace
fi


YEAR="2024"

jq '.[] | select(.type == "Run")' activities/merged.json | \
  jq -s . | jq 'map({start_date_local,distance})' | \
  jq 'map(select(.start_date_local | startswith("'${YEAR}'")))' | \
  jq 'sort_by(.start_date_local)' > activities/run_$YEAR.json

METERS_RAN=$(jq 'map(.distance) | add' activities/run_$YEAR.json)

printf "$YEAR miles = %.1f\n" "$(echo "$METERS_RAN / 1609.34" | bc -l)"
