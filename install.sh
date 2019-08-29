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

dotdir="$PWD/src/dots"

source "$dotdir/bashrc"

mkdir -p $XDG_CONFIG_HOME $XDG_CACHE_HOME $XDG_DATA_HOME

generate_link "$dotdir/vim"
generate_link "$dotdir/vimrc"
generate_link "$dotdir/bashrc"
generate_link "$dotdir/bin"
generate_link "$dotdir/profile"
# generate_link "$dotdir/Xmodmap"
# generate_link "$dotdir/zshrc"

generate_link "$dotdir/bin/data/fonts.conf" "$XDG_CONFIG_HOME/fontconfig/fonts.conf"
generate_link "$dotdir/bin/data/gitconfig"  "$XDG_CONFIG_HOME/git/config"

echo " done!"
