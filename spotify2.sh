#!/bin/bash
(sudo systemctl stop vlcgiz.service; pkill vlc; Xvfb :99 -screen 0 1280x1024x24 & export DISPLAY=:99; /usr/bin/spotify spotify --disable-gpu --disable-gpu-compositing & disown)
echo "started spotify"
