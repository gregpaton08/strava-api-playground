#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
if [[ "${TRACE-0}" == "1" ]]; then
    set -o xtrace
fi

TOKEN=$(cat access_token)

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
rm $ACTIVITIES_DIR/activities_*.json
