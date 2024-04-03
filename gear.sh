#!/usr/bin/env bash

set -Eeuo pipefail

jq '.bikes' athlete.json | \
  jq 'map({name,id})'