#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Screenshots scripts

ICONS_DIR="$HOME/.config/swaync/icons"
SCRIPTS_DIR="$HOME/.scripts"
NOTIFY_CMD_SHOT="notify-send -h string:x-canonical-private-synchronous:shot-notify -u low -i ${ICONS_DIR}/picture.png"

TIME=$(date "+%d-%b_%H-%M-%S")
DIR="$(xdg-user-dir)/Pictures/Screenshots"
FILE="Screenshot_$TIME_${RANDOM}.png"

ACTIVE_WINDOW_CLASS=$(hyprctl -j activewindow | jq -r '(.class)')
ACTIVE_WINDOW_FILE="Screenshot_$TIME_${ACTIVE_WINDOW_CLASS}.png"
ACTIVE_WINDOW_PATH="$DIR/${ACTIVE_WINDOW_FILE}"

# notify and view screenshot
notify_view() {
    if [[ "$1" == "active" ]]; then
        if [[ -e "${ACTIVE_WINDOW_PATH}" ]]; then
            ${NOTIFY_CMD_SHOT} "Screenshot of '${ACTIVE_WINDOW_CLASS}' Saved."
            "${SCRIPTS_DIR}/sounds.sh" --screenshot
        else
            ${NOTIFY_CMD_SHOT} "Screenshot of '${ACTIVE_WINDOW_CLASS}' not Saved"
            "${SCRIPTS_DIR}/sounds.sh" --error
        fi
    elif [[ "$1" == "swappy" ]]; then
		${NOTIFY_CMD_SHOT} "Screenshot Captured."
    else
        local CHECK_FILE="$DIR/$FILE"
        if [[ -e "$CHECK_FILE" ]]; then
            ${NOTIFY_CMD_SHOT} "Screenshot Saved."
            "${SCRIPTS_DIR}/sounds.sh" --screenshot
        else
            ${NOTIFY_CMD_SHOT} "Screenshot NOT Saved."
            "${SCRIPTS_DIR}/sounds.sh" --error
        fi
    fi
}



# countdown
countdown() {
	for SEC in $(seq $1 -1 1); do
		notify-send -h string:x-canonical-private-synchronous:shot-notify -t 1000 -i "$ICONS_DIR"/timer.png "Taking shot in : $SEC"
		sleep 1
	done
}

# take shots
shotnow() {
	cd $DIR && grim - | tee "$FILE" | wl-copy
	sleep 2
	notify_view
}

shot5() {
	countdown '5'
	sleep 1 && cd $DIR && grim - | tee "$FILE" | wl-copy
	sleep 1
	notify_view
	
}

shot10() {
	countdown '10'
	sleep 1 && cd $DIR && grim - | tee "$FILE" | wl-copy
	notify_view
}

shotwin() {
	W_POS=$(hyprctl activewindow | grep 'at:' | cut -d':' -f2 | tr -d ' ' | tail -n1)
	W_SIZE=$(hyprctl activewindow | grep 'size:' | cut -d':' -f2 | tr -d ' ' | tail -n1 | sed s/,/x/g)
	cd $DIR && grim -g "$W_POS $W_SIZE" - | tee "$FILE" | wl-copy
	notify_view
}

shotarea() {
	TMP_FILE=$(mktemp)
	grim -g "$(slurp)" - >"$TMP_FILE"
	if [[ -s "$TMP_FILE" ]]; then
		wl-copy <"$TMP_FILE"
		mv "$TMP_FILE" "$DIR/$FILE"
	fi
	rm "$TMP_FILE"
	notify_view
}

shotactive() {
    ACTIVE_WINDOW_CLASS=$(hyprctl -j activewindow | jq -r '(.class)')
    ACTIVE_WINDOW_FILE="Screenshot_$TIME_${ACTIVE_WINDOW_CLASS}.png"
    ACTIVE_WINDOW_PATH="$DIR/${ACTIVE_WINDOW_FILE}"

    hyprctl -j activewindow | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' | grim -g - "${ACTIVE_WINDOW_PATH}"
	sleep 1
    notify_view "active"  
}

shotswappy() {
	TMP_FILE=$(mktemp)
	grim -g "$(slurp)" - >"$TMP_FILE" && "${SCRIPTS_DIR}/sounds.sh" --screenshot && notify_view "swappy"
	swappy -f - <"$TMP_FILE"
	rm "$TMP_FILE"
}


if [[ ! -d "$DIR" ]]; then
	mkdir -p "$DIR"
fi

if [[ "$1" == "--now" ]]; then
	shotnow
elif [[ "$1" == "--in5" ]]; then
	shot5
elif [[ "$1" == "--in10" ]]; then
	shot10
elif [[ "$1" == "--win" ]]; then
	shotwin
elif [[ "$1" == "--area" ]]; then
	shotarea
elif [[ "$1" == "--active" ]]; then
	shotactive
elif [[ "$1" == "--swappy" ]]; then
	shotswappy
else
	echo -e "Available Options : --now --in5 --in10 --win --area --active --swappy"
fi

exit 0
