#!/usr/bin/env bash
set -euo pipefail

VOL_SCRIPT="/home/giz/media_station/get_vol.sh"

# Extract volume from the first line only
vol="$("$VOL_SCRIPT" | head -n1 || true)"

# If get_vol failed or returned non-numeric, abort (do nothing)
if [[ -z "${vol:-}" || ! "$vol" =~ ^[0-9]+$ ]]; then
  exit 0
fi

# Only act if muted
if [ "$vol" -ne 0 ]; then
  exit 0
fi

# If muted: stop vlc service and kill any remaining processes
sudo systemctl stop vlcgiz.service || true
pkill vlc || true

# Sleep until 08:00 local time, then reboot
now_epoch="$(date +%s)"
target_epoch="$(date -d 'today 08:00' +%s)"

# If we're already past 08:00 for some reason, schedule next day 08:00
if [ "$target_epoch" -le "$now_epoch" ]; then
  target_epoch="$(date -d 'tomorrow 08:00' +%s)"
fi

sleep_seconds=$(( target_epoch - now_epoch ))
sleep "$sleep_seconds"

sudo reboot
