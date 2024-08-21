#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */ 
# This script for selecting wallpapers (SUPER W)

# WALLPAPERS PATH
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

# variables
SCRIPTS_DIR="$HOME/.scripts"
FOCUSED_MONITOR=$(hyprctl monitors | awk '/^Monitor/{name=$2} /focused: yes/{print name}')

# swww transition config
FPS=100
TYPE="any"
DURATION=2
BEZIER=".43,1.19,1,.4"
SWWW_PARAMS="--transition-fps $FPS --transition-type $TYPE --transition-duration $DURATION"

# Check if swaybg is running
if pidof swaybg > /dev/null; then
  pkill swaybg
fi

# Retrieve image files
PICS=($(find "${WALLPAPER_DIR}" -type f \( -iname \*.jpg -o -iname \*.jpeg -o -iname \*.png -o -iname \*.gif \)))
echo "$PICS"
RANDOM_PIC="${PICS[$((RANDOM % ${#PICS[@]}))]}"
RANDOM_PIC_NAME=". random"

# Rofi command
ROFI_COMMAND="rofi -i -show -dmenu -config ~/.config/rofi/config-wallpaper.rasi"


# Sorting Wallpapers
menu() {
  SORTED_OPTIONS=($(printf '%s\n' "${PICS[@]}" | sort))
  # Place ". random" at the beginning with the random picture as an icon
  printf "%s\x00icon\x1f%s\n" "$RANDOM_PIC_NAME" "$RANDOM_PIC"
  for PIC_PATH in "${SORTED_OPTIONS[@]}"; do
    PIC_NAME=$(basename "$PIC_PATH")
    # Displaying .gif to indicate animated images
    if [[ -z $(echo "$PIC_NAME" | grep -i "\.gif$") ]]; then
      printf "%s\x00icon\x1f%s\n" "$(echo "$PIC_NAME" | cut -d. -f1)" "$PIC_PATH"
    else
      printf "%s\n" "$PIC_NAME"
    fi
  done
}

# initiate swww if not running
swww query || swww-daemon --format xrgb

# Choice of wallpapers
main() {
  CHOICE=$(menu | ${ROFI_COMMAND})
  # No CHOICE case
  if [[ -z $CHOICE ]]; then
    exit 0
  fi

  # Random CHOICE case
  if [ "$CHOICE" = "$RANDOM_PIC_NAME" ]; then
    swww img -o $FOCUSED_MONITOR "${RANDOM_PIC}" $SWWW_PARAMS
    exit 0
  fi

  # Find the index of the selected file
  PIC_INDEX=-1
  for i in "${!PICS[@]}"; do
    FILE_NAME=$(basename "${PICS[$i]}")
    if [[ "$FILE_NAME" == "$CHOICE"* ]]; then
      PIC_INDEX=$i
      break
    fi
  done

  if [[ $PIC_INDEX -ne -1 ]]; then
    swww img -o $FOCUSED_MONITOR "${PICS[$PIC_INDEX]}" $SWWW_PARAMS
  else
    echo "Image not found."
    exit 1
  fi
}

# Check if rofi is already running
if pidof rofi > /dev/null; then
  pkill rofi
  exit 0
fi

main

sleep 0.5
sleep 0.2
$SCRIPTS_DIR/refresh.sh

