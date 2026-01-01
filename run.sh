#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
if [[ "${TRACE-0}" == "1" ]]; then
    set -o xtrace
fi

echo "run"

create_run_year_file () {
  jq '.[] | select(.type == "Run")' activities/merged.json | \
    jq -s . | jq 'map({start_date_local,distance})' | \
    jq 'map(select(.start_date_local | startswith("'${YEAR}'")))' | \
    jq 'sort_by(.start_date_local)' > activities/run_$YEAR.json
}

LIFETIME_METERS=0.0
for year in {2022..2025}; do
  YEAR=$year
  create_run_year_file
  METERS_RAN=$(jq 'map(.distance) | add' activities/run_$YEAR.json)
  LIFETIME_METERS=$(echo "$LIFETIME_METERS + $METERS_RAN" | bc)
  printf "$YEAR miles = %.1f\n" "$(echo "$METERS_RAN / 1609.34" | bc -l)"
done

printf "lifetime miles = %.1f\n" "$(echo "$LIFETIME_METERS / 1609.34" | bc -l)"
