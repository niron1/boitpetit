#!/usr/bin/env bash
set -euo pipefail

. /home/giz/media_station/refresh_ctrl_num.sh

vol=$(
  /usr/bin/amixer -c "$simple_ctrls" |
  awk -F'[][]' '
    /Simple mixer control '\''Speaker'\''/ { in_spk=1; next }
    /Simple mixer control/ { in_spk=0 }
    in_spk && /%/ { print $2; exit }
  ' |
  tr -d '%'
)

# Validate output for automation
if [[ -z "${vol:-}" || ! "$vol" =~ ^[0-9]+$ ]]; then
  echo "error: could not determine volume" >&2
  exit 2
fi

echo "$vol"

if [ "$vol" = "0" ]; then
  echo "sound is muted now"
fi

