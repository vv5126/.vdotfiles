#!/bin/bash

[[ $(ps -p $$ -o comm=) == 'zsh' ]] && HOSTNAME="$HOST"

base=(
.bin/lib/lib.shell
.bin/ini/ini.shell
)

for line in ${base[@]}; do
    if [ -f "$HOME/$line" ]; then
        source "$HOME/$line"
    fi
done

unset base

source $HOME/.bin/data/base.conf

if [[ -n "$list" ]]; then
    for line in ${list[@]}; do
        if [ -f "$HOME/$line" ]; then
            source "$HOME/$line"
        fi
    done
fi
