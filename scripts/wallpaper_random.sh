#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Script for Random Wallpaper ( CTRL ALT W)

WALLPAPERS_DIR="$HOME/Pictures/Wallpapers"
SCRIPTS_DIR="$HOME/.scripts"

FOCUSED_MONITOR=$(hyprctl monitors | awk '/^Monitor/{name=$2} /focused: yes/{print name}')

PICS=($(find ${WALLPAPERS_DIR} -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.gif" \)))
RANDOMPICS=${PICS[ $RANDOM % ${#PICS[@]} ]}


# Transition config
FPS=60
TYPE="random"
DURATION=1
BEZIER=".43,1.19,1,.4"
SWWW_PARAMS="--transition-fps $FPS --transition-type $TYPE --transition-duration $DURATION --transition-bezier $BEZIER"


swww query || swww-daemon --format xrgb && swww img -o $FOCUSED_MONITOR ${RANDOMPICS} $SWWW_PARAMS

sleep 1
${SCRIPTS_DIR}/refresh.sh 

