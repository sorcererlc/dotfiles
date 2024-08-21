#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Scripts for volume controls for audio and mic 

ICONS_DIR="$HOME/.config/swaync/icons"
SCRIPTS_DIR="$HOME/.scripts"

# Get Volume
get_volume() {
    VOLUME=$(pamixer --get-volume)
    if [[ "$VOLUME" -eq "0" ]]; then
        echo "Muted"
    else
        echo "$VOLUME%"
    fi
}

# Get icons
get_icon() {
    CURRENT=$(get_volume)
    if [[ "$CURRENT" == "Muted" ]]; then
        echo "$ICONS_DIR/volume-mute.png"
    elif [[ "${CURRENT%\%}" -le 30 ]]; then
        echo "$ICONS_DIR/volume-low.png"
    elif [[ "${CURRENT%\%}" -le 60 ]]; then
        echo "$ICONS_DIR/volume-mid.png"
    else
        echo "$ICONS_DIR/volume-high.png"
    fi
}

# Notify
notify_user() {
    if [[ "$(get_volume)" == "Muted" ]]; then
        notify-send -e -h string:x-canonical-private-synchronous:volume_notif -u low -i "$(get_icon)" "Volume: Muted"
    else
        notify-send -e -h int:value:"$(get_volume | sed 's/%//')" -h string:x-canonical-private-synchronous:volume_notif -u low -i "$(get_icon)" "Volume: $(get_volume)"
        "$SCRIPTS_DIR/Sounds.sh" --volume
    fi
}

# Increase Volume
inc_volume() {
    if [ "$(pamixer --get-mute)" == "true" ]; then
        toggle_mute
    else
        pamixer -i 5 --allow-boost --set-limit 150 && notify_user
    fi
}

# Decrease Volume
dec_volume() {
    if [ "$(pamixer --get-mute)" == "true" ]; then
        toggle_mute
    else
        pamixer -d 5 && notify_user
    fi
}

# Toggle Mute
toggle_mute() {
	if [ "$(pamixer --get-mute)" == "false" ]; then
		pamixer -m && notify-send -e -u low -i "$ICONS_DIR/volume-mute.png" "Volume Switched OFF"
	elif [ "$(pamixer --get-mute)" == "true" ]; then
		pamixer -u && notify-send -e -u low -i "$(get_icon)" "Volume Switched ON"
	fi
}

# Toggle Mic
toggle_mic() {
	if [ "$(pamixer --default-source --get-mute)" == "false" ]; then
		pamixer --default-source -m && notify-send -e -u low -i "$ICONS_DIR/microphone-mute.png" "Microphone Switched OFF"
	elif [ "$(pamixer --default-source --get-mute)" == "true" ]; then
		pamixer -u --default-source u && notify-send -e -u low -i "$ICONS_DIR/microphone.png" "Microphone Switched ON"
	fi
}
# Get Mic Icon
get_mic_icon() {
    CURRENT=$(pamixer --default-source --get-volume)
    if [[ "$CURRENT" -eq "0" ]]; then
        echo "$ICONS_DIR/microphone-mute.png"
    else
        echo "$ICONS_DIR/microphone.png"
    fi
}

# Get Microphone Volume
get_mic_volume() {
    VOLUME=$(pamixer --default-source --get-volume)
    if [[ "$VOLUME" -eq "0" ]]; then
        echo "Muted"
    else
        echo "$VOLUME%"
    fi
}

# Notify for Microphone
notify_mic_user() {
    VOLUME=$(get_mic_volume)
    ICON=$(get_mic_icon)
    notify-send -e -h int:value:"$VOLUME" -h "string:x-canonical-private-synchronous:volume_notif" -u low -i "$ICON" "Mic-Level: $VOLUME"
}

# Increase MIC Volume
inc_mic_volume() {
    if [ "$(pamixer --default-source --get-mute)" == "true" ]; then
        toggle_mic
    else
        pamixer --default-source -i 5 && notify_mic_user
    fi
}

# Decrease MIC Volume
dec_mic_volume() {
    if [ "$(pamixer --default-source --get-mute)" == "true" ]; then
        toggle-mic
    else
        pamixer --default-source -d 5 && notify_mic_user
    fi
}

# Execute accordingly
if [[ "$1" == "--get" ]]; then
	get_volume
elif [[ "$1" == "--inc" ]]; then
	inc_volume
elif [[ "$1" == "--dec" ]]; then
	dec_volume
elif [[ "$1" == "--toggle" ]]; then
	toggle_mute
elif [[ "$1" == "--toggle-mic" ]]; then
	toggle_mic
elif [[ "$1" == "--get-icon" ]]; then
	get_icon
elif [[ "$1" == "--get-mic-icon" ]]; then
	get_mic_icon
elif [[ "$1" == "--mic-inc" ]]; then
	inc_mic_volume
elif [[ "$1" == "--mic-dec" ]]; then
	dec_mic_volume
else
	get_volume
fi
