#!/bin/bash

smkdir() {
    [ -z "${1}" ] && return
    if [ ! -d "${1}" ]; then
        mkdir -p "${1}"
    fi
}

mk_root_link() {
    local src dst dst_dir bak_dir="$HOME/.local/.olddot"

    src="$1"
    dst="$2"

    [ ! -e "$src" ] && return -1
    [ -z "$dst" ] && dst="$HOME/.${src##*/}"
    dst_dir="${dst%/*}"

    [ ! -d "$bak_dir" ] && mkdir -p "$bak_dir"
    [ -e "$dst" ] && mv -f "$dst" "$bak_dir"

    [ ! -d "$dst_dir" ] && mkdir -p "$dst_dir"
    ln -s "$src" "$dst"
}

mk_config_link() {
    local src dst dst_dir bak_dir="$HOME/.config/.oldconfig"

    src="$1" 
    dst="$2"

    [ ! -e "$src" ] && return -1
    [ -z "$dst" ] && dst="$HOME/.config/.${src##*/}"
    dst_dir="${dst%/*}"

    [ ! -d "$bak_dir" ] && mkdir -p "$bak_dir"
    [ -e "$dst" ] && mv -f "$dst" "$bak_dir"

    [ ! -d "$dst_dir" ] && mkdir -p "$dst_dir"
    ln -s "$src" "$dst"

}
# ======================== MAIN

smkdir "$XDG_DATA_HOME"
smkdir "$XDG_CONFIG_HOME"
smkdir "$XDG_CACHE_HOME"
smkdir "$HOME/.cache/historys"
[ ! -L "$HOME/.config" ] && mv "$HOME/.config" "$HOME/.local/config"
smkdir "$HOME/.local/config"

VDOT="$PWD/dots"

# init root dir
mk_root_link "$HOME/.local/config"
mk_root_link "$VDOT/profile"
mk_root_link "$VDOT/bashrc"
mk_root_link "$VDOT/bin"
mk_root_link "$VDOT/vim"
# mk_root_link "$VDOT/zshrc"
# mk_root_link "$VDOT/Xmodmap"

# init config dir
mk_config_link "$VDOT/nvim"
mk_config_link "config/git"

echo " done!"
