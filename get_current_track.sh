#!/usr/bin/env bash

function __giz_get_track_info {
  local dbus_name playback_time
  dbus_name="$(cat /tmp/active_vlc_dbus_name 2>/dev/null)" || return 1

  TRACK_NAME="$(dbus-send --print-reply \
    --dest="$dbus_name" \
    /org/mpris/MediaPlayer2 \
    org.freedesktop.DBus.Properties.Get \
    string:"org.mpris.MediaPlayer2.Player" \
    string:"Metadata" \
    | grep mp3 | tail -1 | sed -n 's/.*string "\(.*\)"/\1/p')"

  PLAYBACK_STATUS="$(dbus-send --print-reply \
    --dest="$dbus_name" \
    /org/mpris/MediaPlayer2 \
    org.freedesktop.DBus.Properties.Get \
    string:"org.mpris.MediaPlayer2.Player" \
    string:"PlaybackStatus" \
    | grep string | sed 's/.*string "\(.*\)"/\1/')"

  playback_time="$(dbus-send --print-reply \
    --dest="$dbus_name" \
    /org/mpris/MediaPlayer2 \
    org.freedesktop.DBus.Properties.Get \
    string:"org.mpris.MediaPlayer2.Player" \
    string:"Position" \
    | grep variant | awk '{print $3}')"

  PLAYBACK_TIME_S=$((playback_time / 1000000))
  MINUTES=$((PLAYBACK_TIME_S / 60))
  SECONDS=$((PLAYBACK_TIME_S % 60))


  # Fallback: if no track detected, but Spotify is running
  if [[ -z "$TRACK_NAME" ]]; then
    if pgrep -x spotify >/dev/null 2>&1; then
      TRACK_NAME="spotify"
      PLAYBACK_STATUS="${PLAYBACK_STATUS:-running}"
      MINUTES=0
      SECONDS=0
    fi
  fi



}

function __giz_print_human {
  local ast_side asterisks
  ast_side=$(( (${#TRACK_NAME} + ${#PLAYBACK_STATUS} + 2 - 13) / 2 ))
  asterisks="$(printf "%*s" "$ast_side" '' | tr ' ' '*')"

  echo "$asterisks Now Playing $asterisks"
  echo "Track: $TRACK_NAME"
  echo "Status: $PLAYBACK_STATUS"
  echo "Time: ${MINUTES}m ${SECONDS}s"
  echo "$asterisks*************$asterisks"
}

function __giz_print_json {
  printf '{\n'
  printf '  "track": "%s",\n' "${TRACK_NAME//\"/\\\"}"
  printf '  "status": "%s",\n' "$PLAYBACK_STATUS"
  printf '  "time": {\n'
  printf '    "minutes": %d,\n' "$MINUTES"
  printf '    "seconds": %d\n' "$SECONDS"
  printf '  }\n'
  printf '}\n'
}

function __giz_help {
  cat <<'EOF'
Usage:
  source ~/media_station/get_current_track.sh   # defines ll() in your shell
  ./get_current_track.sh json                   # prints JSON once

Commands (when executed):
  json     Output current track info as JSON
  help     Show this help
EOF
}

# Define ll only when sourced (Bash-specific, but you are using Bash).
if [[ "${BASH_SOURCE[0]}" != "$0" ]]; then
  function ll {
    ls --color=auto -la "$@"

    if __giz_get_track_info; then
     __giz_print_human
    fi
  }

  return 0 2>/dev/null
fi

case "${1:-help}" in
  json)
    __giz_get_track_info || exit 1
    __giz_print_json
    ;;
  help|*)
    __giz_help
    ;;
esac

