#!/usr/bin/env bash

# Define file_exists function
file_exists() {
    if [ -e "$1" ]; then
        return 0  # File exists
    else
        return 1  # File does not exist
    fi
}

# Kill already running processes
PS=(rofi swaync ags)
for PRS in "${PS[@]}"; do
    if pidof "${PRS}" >/dev/null; then
        pkill "${PRS}"
    fi
done

# quit ags
ags -q

sleep 0.3

# relaunch swaync
sleep 0.5
swaync > /dev/null 2>&1 &

# relaunch ags
ags &

exit 0

