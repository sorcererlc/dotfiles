#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Clipboard Manager. This script uses cliphist, rofi, and wl-copy.

# Actions:
# CTRL Del to delete an entry
# ALT Del to wipe clipboard contents

while true; do
    RESULT=$(
        rofi -i -dmenu \
            -kb-custom-1 "Control-Delete" \
            -kb-custom-2 "Alt-Delete" \
            -config ~/.config/rofi/config-clipboard.rasi < <(cliphist list)
    )

    case "$?" in
        1)
            exit
            ;;
        0)
            case "$RESULT" in
                "")
                    continue
                    ;;
                *)
                    cliphist decode <<<"$RESULT" | wl-copy
                    exit
                    ;;
            esac
            ;;
        10)
            cliphist delete <<<"$RESULT"
            ;;
        11)
            cliphist wipe
            ;;
    esac
done


