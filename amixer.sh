#!/bin/bash

DATE_TO_IGNORE_CRON=$(cat /home/giz/ignored_date)

# Check if /home/giz/ignored_datetime_start exists and is not empty
if [ -s /home/giz/ignored_datetime_start ]; then
    DATETIME_TO_IGNORE_START=$(cat /home/giz/ignored_datetime_start)  # Read datetime to ignore
    # Try to convert it to a UNIX timestamp, if invalid, skip the 2-hour check
    if ! START_UNIX_TIME=$(date -d "$DATETIME_TO_IGNORE_START" +%s 2>/dev/null); then
        echo "Invalid datetime format in /home/giz/ignored_datetime_start, ignoring the 2-hour check."
        START_UNIX_TIME=0  # Fallback to avoid errors in calculations
    fi
else
    echo "/home/giz/ignored_datetime_start is missing or empty, ignoring the 2-hour check."
    START_UNIX_TIME=0  # Fallback to avoid errors in calculations
fi

CURRENT_UNIX_TIME=$(date +%s)  # Current time in UNIX timestamp
TWO_HOURS_IN_SECONDS=7200
TIME_ELAPSED=$((CURRENT_UNIX_TIME - START_UNIX_TIME))

if [ $# -eq 0 ]; then
    echo "No arguments supplied"
    exit 1
fi

FORCE_FLAG=0
ARGS=()

for arg in "$@"; do
  case $arg in
    --force)
      FORCE_FLAG=1
      ;;
    *)
      ARGS+=("$arg")
      ;;
  esac
done

echo "Force flag: $FORCE_FLAG"
echo "Other arguments: ${ARGS[@]}"

TOTAL_MUTE_COMMAND="false"
if [[ $* =~ "Speaker 0%" ]]; then
    TOTAL_MUTE_COMMAND="true"
fi

TODAY=$(date +%Y%m%d)
HOUR=$(date +%H:%M:%S)

# If today's date matches DATE_TO_IGNORE_CRON or if less than 2 hours have passed from DATETIME_TO_IGNORE_START
if ([[ "$TODAY" == "$DATE_TO_IGNORE_CRON" ]] || ([[ $START_UNIX_TIME -ne 0 ]] && [[ $TIME_ELAPSED -lt $TWO_HOURS_IN_SECONDS ]])) && [[ "$TOTAL_MUTE_COMMAND" == "false" ]] && [[ $FORCE_FLAG -ne 1 ]]; then
   echo "$TODAY $HOUR nir: *NOT* sending command to amixer due to date or recent ignore start time:" "${ARGS[@]}"
else
   echo "$TODAY $HOUR nir: sending to amixer...:" "${ARGS[@]}"
   /usr/bin/amixer "${ARGS[@]}" 2>&1 > /dev/null
fi

