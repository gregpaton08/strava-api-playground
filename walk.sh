#!/usr/bin/env bash

set -Eeuo pipefail

# Get non-Rusty walks
# jq '.[] | select(.name != "Rusty")' activities/walk_2024.json

jq '.[] | select(.type == "Walk")' activities/merged.json | \
  jq -s . | \
  jq 'map({name,start_date_local,distance})' | \
  jq 'sort_by(.start_date_local)' > activities/walk_lifetime.json

jq 'map(select(.start_date_local | startswith("2022")))' activities/walk_lifetime.json > activities/walk_2022.json
jq 'map(select(.start_date_local | startswith("2023")))' activities/walk_lifetime.json > activities/walk_2023.json
jq 'map(select(.start_date_local | startswith("2024")))' activities/walk_lifetime.json > activities/walk_2024.json

METERS_IN_MILE=1609.34
meters_walked=$(jq 'map(.distance) | add' activities/walk_2022.json)
MILES_WALKED=$(echo "$meters_walked / $METERS_IN_MILE" | bc -l)
NUM_WALKS=$(jq length activities/walk_2022.json)
printf "2022     %4.0f\tmiles = %.2f\n" ${NUM_WALKS} ${MILES_WALKED}

meters_walked=$(jq 'map(.distance) | add' activities/walk_2023.json)
MILES_WALKED=$(echo "$meters_walked / $METERS_IN_MILE" | bc -l)
NUM_WALKS=$(jq length activities/walk_2023.json)
printf "2023     %4.0f\tmiles = %.2f\n" ${NUM_WALKS} ${MILES_WALKED}

meters_walked=$(jq 'map(.distance) | add' activities/walk_2024.json)
MILES_WALKED=$(echo "$meters_walked / $METERS_IN_MILE" | bc -l)
NUM_WALKS=$(jq length activities/walk_2024.json)
printf "2024     %4.0f\tmiles = %.2f\n" ${NUM_WALKS} ${MILES_WALKED}

meters_walked=$(jq 'map(.distance) | add' activities/walk_lifetime.json)
MILES_WALKED=$(echo "${meters_walked} / ${METERS_IN_MILE}" | bc -l)
NUM_WALKS=$(jq length activities/walk_lifetime.json)
printf "lifetime %4.0f\tmiles = %.2f\n" ${NUM_WALKS} ${MILES_WALKED}
