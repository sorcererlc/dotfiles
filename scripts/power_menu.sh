#!/usr/bin/env bash

# Set variables for parameters
A_2160=450
B_2160=450
A_1600=400
B_1600=400
A_1440=350
B_1440=350
A_1080=350
B_1080=350
A_720=50
B_720=50

# Check if wlogout is already running
if pgrep -x "wlogout" > /dev/null; then
    pkill -x "wlogout"
    exit 0
fi

# Detect monitor resolution and scaling factor
RESOLUTION=$(hyprctl -j monitors | jq -r '.[] | select(.focused==true) | .height / .scale' | awk -F'.' '{print $1}')
HYPR_SCALE=$(hyprctl -j monitors | jq -r '.[] | select(.focused==true) | .scale')

# Set parameters based on screen resolution and scaling factor
if ((RESOLUTION >= 2160)); then
    T_val=$(awk "BEGIN {printf \"%.0f\", $A_2160 * 2160 * $HYPR_SCALE / $RESOLUTION}")
    B_val=$(awk "BEGIN {printf \"%.0f\", $B_2160 * 2160 * $HYPR_SCALE / $RESOLUTION}")
    echo "Setting parameters for resolution >= 4k"
    wlogout --protocol layer-shell -b 6 -T $T_val -B $B_val &
elif ((RESOLUTION >= 1600 && RESOLUTION < 2160)); then
    T_val=$(awk "BEGIN {printf \"%.0f\", $A_1600 * 1600 * $HYPR_SCALE / $RESOLUTION}")
    B_val=$(awk "BEGIN {printf \"%.0f\", $B_1600 * 1600 * $HYPR_SCALE / $RESOLUTION}")
    echo "Setting parameters for resolution >= 2.5k and < 4k"
    wlogout --protocol layer-shell -b 6 -T $T_val -B $B_val &
elif ((RESOLUTION >= 1440 && RESOLUTION < 1600)); then
    T_val=$(awk "BEGIN {printf \"%.0f\", $A_1440 * 1440 * $HYPR_SCALE / $RESOLUTION}")
    B_val=$(awk "BEGIN {printf \"%.0f\", $B_1440 * 1440 * $HYPR_SCALE / $RESOLUTION}")
    echo "Setting parameters for resolution >= 2k and < 2.5k"
    wlogout --protocol layer-shell -b 6 -T $T_val -B $B_val &
elif ((RESOLUTION >= 1080 && RESOLUTION < 1440)); then
    T_val=$(awk "BEGIN {printf \"%.0f\", $A_1080 * 1080 * $HYPR_SCALE / $RESOLUTION}")
    B_val=$(awk "BEGIN {printf \"%.0f\", $B_1080 * 1080 * $HYPR_SCALE / $RESOLUTION}")
    echo "Setting parameters for resolution >= 1080p and < 2k"
    wlogout --protocol layer-shell -b 6 -T $T_val -B $B_val &
elif ((RESOLUTION >= 720 && RESOLUTION < 1080)); then
    T_val=$(awk "BEGIN {printf \"%.0f\", $A_720 * 720 * $HYPR_SCALE / $RESOLUTION}")
    B_val=$(awk "BEGIN {printf \"%.0f\", $B_720 * 720 * $HYPR_SCALE / $RESOLUTION}")
    echo "Setting parameters for resolution >= 720p and < 1080p"
    wlogout --protocol layer-shell -b 3 -T $T_val -B $B_val &
else
    echo "Setting default parameters"
    wlogout &
fi
