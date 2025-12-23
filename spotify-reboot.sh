#!/bin/bash

# start spotify and keep its PID
/usr/bin/ssh giz@127.0.0.1 /home/giz/media_station/spotify2.sh &
SPOTIFY_PID=$!

# start delayed reboot watcher
(
  sleep 1800
  sudo reboot
) &
REBOOT_PID=$!

# wait for spotify to exit
wait "$SPOTIFY_PID"

# cancel reboot if still pending
kill "$REBOOT_PID" 2>/dev/null

echo "spotify2 finished, reboot cancelled"

