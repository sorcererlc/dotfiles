#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# This is for polkits, it will start from top and will stop if the top is executed

# Polkit possible paths files to check
POLKIT=(
  "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"
  "/usr/lib/polkit-kde-authentication-agent-1"
  "/usr/lib/polkit-gnome-authentication-agent-1"
  "/usr/libexec/polkit-gnome-authentication-agent-1"
  "/usr/lib/x86_64-linux-gnu/libexec/polkit-kde-authentication-agent-1"
  "/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1"
)

EXECUTED=false  # Flag to track if a file has been executed

# Loop through the list of files
for FILE in "${POLKIT[@]}"; do
  if [ -e "$FILE" ]; then
    echo "File $FILE found, executing command..."
    exec "$FILE"  
    EXECUTED=true
    break
  fi
done

# If none of the files were found, you can add a fallback command here
if [ "$EXECUTED" == false ]; then
  echo "None of the specified files were found. Install a Polkit"
fi
