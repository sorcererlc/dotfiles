#!/usr/bin/env bash

check_fedora() {
  dnf check-update | awk 'NR>2 {print last} {last=$0}' | wc -l
}

check_arch() {
  checkupdates | wc -l
}

if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$NAME
    VER=$VERSION_ID
fi

case $OS in
    "Fedora Linux")
    check_fedora
    ;;
    "Arch Linux")
    check_arch
    ;;
    *) echo "$OS is not yet supported. Feel free to make a pull request and add support for your distro.";;
esac
