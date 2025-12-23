#!/bin/bash

# Define the file where the current timestamp will be written
IGNORE_DATETIME_FILE="/home/giz/ignored_datetime_start"

# Get the current timestamp in the format YYYY-MM-DD HH:MM:SS
CURRENT_TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

# Write the current timestamp into the ignored_datetime_start file
echo "$CURRENT_TIMESTAMP" > "$IGNORE_DATETIME_FILE"

# Confirm the action
echo "Current timestamp $CURRENT_TIMESTAMP has been written to $IGNORE_DATETIME_FILE"

