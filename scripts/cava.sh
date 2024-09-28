#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##

# Not my own work. This was added through Github PR. Credit to original author

#----- Optimized bars animation without much CPU usage increase --------
BAR="▁▂▃▄▅▆▇█"
DICT="s/;//g"

# Calculate the length of the bar outside the loop
BAR_LENGTH=${#BAR}

# Create dictionary to replace char with bar
for ((i = 0; i < BAR_LENGTH; i++)); do
    DICT+=";s/$i/${BAR:$i:1}/g"
done

# Create cava config
CONFIG_FILE="$HOME/.config/cava/bar_cava_config"

# Kill cava if it's already running
pkill -f "cava -p $CONFIG_FILE"

# Read stdout from cava and perform substitution in a single sed command
cava -p "$CONFIG_FILE" | sed -u "$DICT"
