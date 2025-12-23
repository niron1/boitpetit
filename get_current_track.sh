#!/bin/bash

ll() {
    ls --color=auto -la "$@";
    DBUS_NAME=$(cat /tmp/active_vlc_dbus_name)

    # Get current track name
    TRACK_NAME=$(dbus-send --print-reply --dest=$DBUS_NAME /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:"org.mpris.MediaPlayer2.Player" string:"Metadata" | grep mp3 | tail -1 | sed -n 's/.*string "\(.*\)"/\1/p');
    # Get playback status
    PLAYBACK_STATUS=$(dbus-send --print-reply --dest=$DBUS_NAME /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:"org.mpris.MediaPlayer2.Player" string:"PlaybackStatus" | grep string | sed 's/.*string "\(.*\)"/\1/')
    
    # Get playback time
    PLAYBACK_TIME=$(dbus-send --print-reply --dest=$DBUS_NAME /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:"org.mpris.MediaPlayer2.Player" string:"Position" | grep variant | awk '{print $3}')
    
    # Convert playback time from microseconds to minutes and seconds
    PLAYBACK_TIME_S=$((PLAYBACK_TIME / 1000000))
    MINUTES=$((PLAYBACK_TIME_S / 60))
    SECONDS=$((PLAYBACK_TIME_S % 60))
    
    AST_SIDE_SIZE=$(( (${#TRACK_NAME} + ${#PLAYBACK_STATUS} + 2 - 13) / 2 ));
    ASTERISKS=$(printf "%*s" $AST_SIDE_SIZE '' | tr ' ' '*');
    
    echo "$ASTERISKS Now Playing $ASTERISKS";
    echo "Track: $TRACK_NAME";
    echo "Status: $PLAYBACK_STATUS";
    echo "Time: ${MINUTES}m ${SECONDS}s";
    echo "$ASTERISKS*************$ASTERISKS"
}

