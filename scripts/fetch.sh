#!/usr/bin/env bash

if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$NAME
    VER=$VERSION_ID
fi

fastfetch # -l "$HOME/.config/fastfetch/$OS.png"
