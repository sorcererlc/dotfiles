#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Script for keyboard backlights (if supported) using brightnessctl

ICONS_DIR="$HOME/.config/swaync/icons"

# Get keyboard brightness
get_kbd_backlight() {
	echo $(brightnessctl -d '*::kbd_backlight' -m | cut -d, -f4)
}

# Get icons
get_icon() {
	CURRENT=$(get_kbd_backlight | sed 's/%//')
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
	notify-send -e -h string:x-canonical-private-synchronous:brightness_notif -h int:value:$CURRENT -u low -i "$ICON" "Keyboard Brightness : $CURRENT%"
}

# Change brightness
change_kbd_backlight() {
	brightnessctl -d *::kbd_backlight set "$1" && get_icon && notify_user
}

# Execute accordingly
case "$1" in
	"--get")
		get_kbd_backlight
		;;
	"--inc")
		change_kbd_backlight "+30%"
		;;
	"--dec")
		change_kbd_backlight "30%-"
		;;
	*)
		get_kbd_backlight
		;;
esac
