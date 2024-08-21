#!/usr/bin/env bash

setup_fedora() {
  sudo dnf upgrade
}

setup_arch() {
  sudo pacman -Syu
  paru -Syu
}

setup_debian() {
  sudo apt-get update && sudo apt-get upgrade
}

if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$NAME
    VER=$VERSION_ID
fi

notify-send "Updating $OS $VER"

case $OS in
    "Fedora Linux")
    setup_fedora
    ;;
    "Arch Linux")
    setup_arch
    ;;
    "Debian GNU/Linux")
    setup_debian
    ;;
    "Ubuntu")
    setup_debian
    ;;
    *) echo "$OS is not yet supported. Feel free to make a pull request and add support for your distro.";;
esac

flatpak update

notify-send 'The system has been updated'
