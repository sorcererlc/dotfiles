#!/usr/bin/env bash

icon="$HOME/.config/swaync/images/bell.png"

blocked=$(rfkill list wifi | grep -o "Soft blocked: yes")

if [ -n "$blocked" ]; then
  rfkill unblock wifi
  notify-send -u low -i "$icon" 'Airplane mode: OFF'
else
  rfkill block wifi
  notify-send -u low -i "$icon" 'Airplane mode: ON'
fi
