#!/bin/bash

if pgrep -x "waybar" >/dev/null; then
    pkill waybar
    sleep 0.2  # Delay for Waybar to completely terminate
fi
waybar &