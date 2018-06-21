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

if [ -d "$HOME/.bin/account/$USER@$HOSTNAME" ]; then
    add_path "$HOME/.bin/account/$USER@$HOSTNAME"
    source "$HOME/.bin/account/$USER@$HOSTNAME/init"
fi
