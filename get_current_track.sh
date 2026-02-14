#!/bin/bash
function __giz_get_track_info {
  local dbus_name playback_time
  local s_title s_artist s_status s_pos

  # Reset outputs for each call (prevents stale values)
  TRACK_NAME=""
  PLAYBACK_STATUS=""
  MINUTES=0
  SECONDS=0

  dbus_name="$(cat /tmp/active_vlc_dbus_name 2>/dev/null)" || true

  # --- VLC path (preserve previous behavior; just silence errors) ---
  if [[ -n "$dbus_name" ]]; then
    TRACK_NAME="$(dbus-send --print-reply \
      --dest="$dbus_name" \
      /org/mpris/MediaPlayer2 \
      org.freedesktop.DBus.Properties.Get \
      string:"org.mpris.MediaPlayer2.Player" \
      string:"Metadata" \
      2>/dev/null | grep mp3 | tail -1 | sed -n 's/.*string "\(.*\)"/\1/p')"

    PLAYBACK_STATUS="$(dbus-send --print-reply \
      --dest="$dbus_name" \
      /org/mpris/MediaPlayer2 \
      org.freedesktop.DBus.Properties.Get \
      string:"org.mpris.MediaPlayer2.Player" \
      string:"PlaybackStatus" \
      2>/dev/null | grep string | sed 's/.*string "\(.*\)"/\1/')"

    playback_time="$(dbus-send --print-reply \
      --dest="$dbus_name" \
      /org/mpris/MediaPlayer2 \
      org.freedesktop.DBus.Properties.Get \
      string:"org.mpris.MediaPlayer2.Player" \
      string:"Position" \
      2>/dev/null | grep variant | awk '{print $3}')"

    if [[ -n "$TRACK_NAME" ]]; then
      PLAYBACK_STATUS="${PLAYBACK_STATUS:-running}"

      if [[ -n "$playback_time" ]]; then
        PLAYBACK_TIME_S=$((playback_time / 1000000))
        MINUTES=$((PLAYBACK_TIME_S / 60))
        SECONDS=$((PLAYBACK_TIME_S % 60))
      else
        MINUTES=0
        SECONDS=0
      fi

      return 0
    fi
  fi

  # --- Spotify fallback (use playerctl; your system confirms it works) ---
  if command -v playerctl >/dev/null 2>&1; then
    # If spotify is available as a player, this returns 0
    if playerctl -p spotify status >/dev/null 2>&1; then
      s_title="$(playerctl -p spotify metadata xesam:title 2>/dev/null) (Spotify)"
      s_artist="$(playerctl -p spotify metadata xesam:artist 2>/dev/null | head -1)"
      s_status="$(playerctl -p spotify status 2>/dev/null)"
      s_pos="$(playerctl -p spotify position 2>/dev/null)"

      if [[ -n "$s_title" && -n "$s_artist" ]]; then
        TRACK_NAME="$s_artist - $s_title"
      elif [[ -n "$s_title" ]]; then
        TRACK_NAME="$s_title"
      else
        TRACK_NAME="spotify"
      fi

      PLAYBACK_STATUS="${s_status:-running}"

      if [[ -n "$s_pos" ]]; then
        # playerctl position is seconds (often float)
        PLAYBACK_TIME_S="${s_pos%.*}"
        MINUTES=$((PLAYBACK_TIME_S / 60))
        SECONDS=$((PLAYBACK_TIME_S % 60))
      else
        MINUTES=0
        SECONDS=0
      fi

      return 0
    fi
  fi

  return 1
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

