#!/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/../utils/clone.sh"
source "$(dirname "${BASH_SOURCE[0]}")/../utils/symlink.sh"

THEME_NAME="ArcDusk-cursors"

clone "yeyushengfan258/ArcDusk-Cursors" ~/.local/share/icons/ArcDusk-Cursors-git

create_symlink ~/.local/share/icons/ArcDusk-Cursors-git/dist ~/.local/share/icons/$THEME_NAME

hyprctl setcursor "$THEME_NAME" 24
gsettings set org.gnome.desktop.interface cursor-theme "$THEME_NAME"
gsettings set org.gnome.desktop.interface cursor-size 24
