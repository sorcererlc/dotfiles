#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Script for Monitor backlights (if supported) using brightnessctl

ICONS_DIR="$HOME/.config/swaync/icons"
NOTIFICATION_TIMEOUT=1000
STEP=10  # INCREASE/DECREASE BY THIS VALUE

# Get brightness
get_backlight() {
	brightnessctl -m | cut -d, -f4 | sed 's/%//'
}

# Get icons
get_icon() {
	CURRENT=$(get_backlight)
	if   [ "$CURRENT" -le "20" ]; then
		ICON="$ICONS_DIR/brightness-20.png"
	elif [ "$CURRENT" -le "40" ]; then
		ICON="$ICONS_DIR/brightness-40.png"
	elif [ "$CURRENT" -le "60" ]; then
		ICON="$ICONS_DIR/brightness-60.png"
	elif [ "$CURRENT" -le "80" ]; then
		ICON="$ICONS_DIR/brightness-80.png"
	else
		ICON="$ICONS_DIR/brightness-100.png"
	fi
}

# Notify
notify_user() {
	notify-send -e -h string:x-canonical-private-synchronous:brightness_notif -h int:value:$CURRENT -u low -i "$ICON" "Brightness : $CURRENT%"
}

# Change brightness
change_backlight() {
	local CURRENT_BRIGHTNESS
	CURRENT_BRIGHTNESS=$(get_backlight)

	# Calculate new brightness
	if [[ "$1" == "+${STEP}%" ]]; then
		NEW_BRIGHTNESS=$((CURRENT_BRIGHTNESS + STEP))
	elif [[ "$1" == "${STEP}%-" ]]; then
		NEW_BRIGHTNESS=$((CURRENT_BRIGHTNESS - STEP))
	fi

	# Ensure new brightness is within valid range
	if (( NEW_BRIGHTNESS < 5 )); then
		NEW_BRIGHTNESS=5
	elif (( NEW_BRIGHTNESS > 100 )); then
		NEW_BRIGHTNESS=100
	fi

	brightnessctl set "${NEW_BRIGHTNESS}%"
	get_icon
	CURRENT=$NEW_BRIGHTNESS
	notify_user
}

# Execute accordingly
case "$1" in
	"--get")
		get_backlight
		;;
	"--inc")
		change_backlight "+${STEP}%"
		;;
	"--dec")
		change_backlight "${STEP}%-"
		;;
	*)
		get_backlight
		;;
esac
