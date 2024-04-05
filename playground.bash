#!/usr/bin/env bash

TOKEN=$(cat access_token)


# http 
# curl -X GET "https://www.strava.com/api/v3/athlete" -H "Authorization: Bearer $TOKEN" > athlete.json


# http get "https://www.strava.com/api/v3/gear/{id}" "Authorization: Bearer [[$TOKEN]]"


BIKE_ID="b11645909"
# curl -X GET "https://www.strava.com/api/v3/gear/$BIKE_ID" -H "Authorization: Bearer $TOKEN" > specialized_on_kickr.json



# before=&after=&
PER_PAGE=100
RESULT_LENGTH=$PER_PAGE
PAGE=1
ACTIVITIES_DIR="activities"
mkdir -p $ACTIVITIES_DIR
while [[ "$RESULT_LENGTH" == "$PER_PAGE" ]]; do
    OUTPUT_FILE="$ACTIVITIES_DIR/activities_$PAGE.json"
    curl -X GET "https://www.strava.com/api/v3/athlete/activities?page=$PAGE&per_page=$PER_PAGE"  -H "Authorization: Bearer $TOKEN" > $OUTPUT_FILE

    RESULT_LENGTH=$(jq 'length' $OUTPUT_FILE)

    PAGE=$((PAGE+1))
done

cat $ACTIVITIES_DIR/activities_*.json | jq -s 'flatten' > $ACTIVITIES_DIR/merged.json

exit 0

SPECIALIZED_ON_KICKR_ID="b11645909"
SPECIALIZED_SL4_ID="b10891838"

jq '.[] | select(.gear_id == "b10891838")' activities/merged.json | jq -s '.'

jq '{ "sum": map(.distance) | add }' activities/mileage_over_time.json


# jq 'map({start_date_local,distance})'


jq '.[] | select(.gear_id == "b11645909")' activities/merged.json | jq -s . | jq 'map({start_date_local,distance})' | jq 'sort_by(.start_date_local)' | jq 'map(select(.start_date_local | startswith("2023")))' > activities/specialized_on_kickr_mileage_over_time_2023.json
jq 'map(.distance) | add' activities/specialized_on_kickr_mileage_over_time_2023.json


jq '.[] | select(.gear_id == "b11645909")' activities/merged.json | jq -s . | jq 'map({start_date_local,distance})' | jq 'sort_by(.start_date_local)' | jq 'map(select(.start_date_local | startswith("2022")))' > activities/specialized_on_kickr_mileage_over_time_2022.json
jq 'map(.distance) | add' activities/specialized_on_kickr_mileage_over_time_2022.json


jq '.[] | select(.gear_id == "b11645909")' activities/merged.json | jq -s . | jq 'map({start_date_local,distance})' | jq 'sort_by(.start_date_local)' > activities/specialized_on_kickr_mileage_over_time.json
jq 'map(.distance) | add' activities/specialized_on_kickr_mileage_over_time.json



jq '.[] | select(.type == "Walk")' activities/merged.json | jq -s . | jq 'map({start_date_local,distance})' | jq 'sort_by(.start_date_local)' | jq 'map(select(.start_date_local | startswith("2023")))' > activities/walking_2023.json
jq 'map(.distance) | add' activities/walking_2023.json

jq 'map(select(.name | test("(?i)rusty")))' activities/merged.json | jq 'map(select(.start_date_local | startswith("2023")))'  > activities/rusty_2023.json
jq 'map(.distance) | add' activities/rusty_2023.json


jq '.[] | select(.type == "Ride")' activities/merged.json | jq -s . | jq 'map({start_date_local,distance})' | jq 'sort_by(.start_date_local)' | jq 'map(select(.start_date_local | startswith("2022")))' > activities/ride_2022.json
jq 'map(.distance) | add' activities/ride_2022.json


jq '.[] | select(.type == "Run")' activities/merged.json | jq -s . | jq 'map({start_date_local,distance})' | jq 'map(select(.start_date_local | startswith("2023")))' | jq 'sort_by(.start_date_local)' > activities/run_2023.json