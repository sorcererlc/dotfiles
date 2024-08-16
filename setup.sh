#!/usr/bin/env bash

SOURCE_DIRS=( "$PWD/config" "$PWD/scripts" "$PWD/themes/home" "$PWD/themes/local_share" )
DEST_DIRS=( "$HOME/.config" "$HOME/.scripts" "$HOME/.themes" "$HOME/.local/share/" )

for ((i=0; i < ${#SOURCE_DIRS[@]}; i++)); do
  dir="${SOURCE_DIRS[i]}/*/"
  for src in $dir
  do
    src=${src%*/}
    target="${DEST_DIRS[i]}/${src##*/}"

    if [ -e "$target" ]; then
      read -p "WARNING: $target aleardy exists. Overwrite? (y/N)" proceed
      if [ "$proceed" == "y" ]; then
        echo "Overwriting $target"
        rm -rf $target
        ln -s "$src" "$target"
      fi
      
      continue
    fi

    echo "Linking $src to $target"
    ln -s "$src" "$target"
  done
done

echo "Installing Catppuccin GTK theme."
python3 $PWD/themes/catppuccin_gtk_install.py mocha mauve

flatpak override --filesystem=$HOME/.themes:ro --filesystem=$HOME/.local/share/themes --filesystem=$HOME/.icons:ro --user
flatpak override --env=GTK_THEME="catppuccin-mocha-mauve-standard+default" --user
