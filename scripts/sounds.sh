#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# This script is used to play system sounds.
# Script is used by Volume.Sh and ScreenShots.sh 

THEME="freedesktop" # Set the theme for the system sounds.
MUTE=false          # Set to true to mute the system sounds.

# Mute individual sounds here.
MUTE_SCREENSHOTS=false
MUTE_VOLUME=false

# Exit if the system sounds are muted.
if [[ "$MUTE" = true ]]; then
    exit 0
fi

# Choose the sound to play.
if [[ "$1" == "--screenshot" ]]; then
    if [[ "$MUTE_SCREENSHOTS" = true ]]; then
        exit 0
    fi
    SOUND_OPTION="screen-capture.*"
elif [[ "$1" == "--volume" ]]; then
    if [[ "$MUTE_VOLUME" = true ]]; then
        exit 0
    fi
    SOUND_OPTION="audio-volume-change.*"
elif [[ "$1" == "--error" ]]; then
    if [[ "$MUTE_SCREENSHOTS" = true ]]; then
        exit 0
    fi
    SOUND_OPTION="dialog-error.*"
else
    echo -e "Available sounds: --screenshot, --volume, --error"
    exit 0
fi

# Set the directory defaults for system sounds.
if [ -d "/run/current-system/sw/share/sounds" ]; then
    SYSTEM_DIR="/run/current-system/sw/share/sounds" # NixOS
else
    SYSTEM_DIR="/usr/share/sounds"
fi
USER_DIR="$HOME/.local/share/sounds"
DEFAULT_THEME="freedesktop"

# Prefer the user's theme, but use the system's if it doesn't exist.
SDIR="$SYSTEM_DIR/$DEFAULT_THEME"
if [ -d "$USER_DIR/$THEME" ]; then
    SDIR="$USER_DIR/$THEME"
elif [ -d "$SYSTEM_DIR/$THEME" ]; then
    SDIR="$SYSTEM_DIR/$THEME"
fi

# Get the theme that it inherits.
INHERITED_THEME=$(cat "$SDIR/index.theme" | grep -i "inherits" | cut -d "=" -f 2)
IDIR="$SDIR/../$INHERITED_THEME"

# Find the sound file and play it.
SOUND_FILE=$(find $SDIR/stereo -name "$SOUND_OPTION" -print -quit)
if ! test -f "$SOUND_FILE"; then
    SOUND_FILE=$(find $IDIR/stereo -name "$SOUND_OPTION" -print -quit)
    if ! test -f "$SOUND_FILE"; then
        SOUND_FILE=$(find $USER_DIR/$DEFAULT_THEME/stereo -name "$SOUND_OPTION" -print -quit)
        if ! test -f "$SOUND_FILE"; then
            SOUND_FILE=$(find $SYSTEM_DIR/$DEFAULT_THEME/stereo -name "$SOUND_OPTION" -print -quit)
            if ! test -f "$SOUND_FILE"; then
                echo "Error: Sound file not found."
                exit 1
            fi
        fi
    fi
fi

# pipewire priority, fallback pulseaudio
pw-play "$SOUND_FILE" || pa-play "$SOUND_FILE"
