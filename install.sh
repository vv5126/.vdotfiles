#!/bin/bash

generate_link() {
    local src dst dst_dir bak_dir="$HOME/.local/.olddot"

    src="$1" dst="$2"

    [ ! -e "$src" ] && return -1
    [ -z "$dst" ] && dst="$HOME/.${src##*/}"
    dst_dir="${dst%/*}"

    [ ! -d "$bak_dir" ] && mkdir -p "$bak_dir"
    [ -e "$dst" ] && mv -f "$dst" "$bak_dir"

    [ ! -d "$dst_dir" ] && mkdir -p "$dst_dir"
    ln -s "$src" "$dst"
}

# ======================== MAIN

VDOT="$PWD/dots"
source "$VDOT/bashrc"

lib.base smkdir "$HOME/.local/tmp"
lib.base smkdir "$XDG_DATA_HOME"
lib.base smkdir "$XDG_CONFIG_HOME"
lib.base smkdir "$XDG_CACHE_HOME"

# generate_link "$VDOT/bin/data/fonts.conf" "$XDG_CONFIG_HOME/fontconfig/fonts.conf"
# generate_link "$VDOT/bin/data/gitconfig"  "$XDG_CONFIG_HOME/git/config"

# ----------------------------------
cp "$VDOT/profile" $HOME/.profile
generate_link "$VDOT/bashrc"
generate_link "$VDOT/bin"
generate_link "$VDOT/vim"
# generate_link "$VDOT/zshrc"
# generate_link "$VDOT/Xmodmap"
# generate_link "$VDOT/zshrc"

echo " done!"
