#!/usr/bin/env bash

set -Eeuo pipefail

KICKR_CANNON_ID="b13729442"
SPECIALIZED_ON_KICKR_ID="b11645909"

jq '.[] | select(.type == "Ride" and .trainer == false and .gear_id != "'"${SPECIALIZED_ON_KICKR_ID}"'" and .gear_id != "'"${KICKR_CANNON_ID}"'")' activities/merged.json | \
  jq -s . | \
  jq 'map({name,start_date_local,distance,trainer,gear_id})' | \
  jq 'sort_by(.start_date_local)' > activities/ride_lifetime.json

jq 'map(select(.start_date_local | startswith("2022")))' activities/ride_lifetime.json > activities/ride_2022.json
jq 'map(select(.start_date_local | startswith("2023")))' activities/ride_lifetime.json > activities/ride_2023.json
jq 'map(select(.start_date_local | startswith("2024")))' activities/ride_lifetime.json > activities/ride_2024.json

METERS_IN_MILE=1609.34
meters_ridden=$(jq 'map(.distance) | add' activities/ride_2022.json)
MILES_RIDDEN=$(echo "$meters_ridden / $METERS_IN_MILE" | bc -l)
printf "2022 miles = %.2f\n" ${MILES_RIDDEN}

meters_ridden=$(jq 'map(.distance) | add' activities/ride_2023.json)
MILES_RIDDEN=$(echo "$meters_ridden / $METERS_IN_MILE" | bc -l)
printf "2023 miles = %.2f\n" ${MILES_RIDDEN}

meters_ridden=$(jq 'map(.distance) | add' activities/ride_2024.json)
MILES_RIDDEN=$(echo "$meters_ridden / $METERS_IN_MILE" | bc -l)
printf "2024 miles = %.2f\n" ${MILES_RIDDEN}

meters_ridden=$(jq 'map(.distance) | add' activities/ride_lifetime.json)
MILES_RIDDEN=$(echo "${meters_ridden} / ${METERS_IN_MILE}" | bc -l)
printf "lifetime miles = %.2f\n" ${MILES_RIDDEN}
