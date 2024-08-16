#!/usr/bin/env bash

SOURCE_DIRS=( "$PWD/config" "$PWD/themes" )
DEST_DIRS=( "$HOME/.config" "$HOME/.themes" )

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
