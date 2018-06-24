#!/bin/bash

[[ $(ps -p $$ -o comm=) == 'zsh' ]] && HOSTNAME="$HOST"

function include() {
    [[ "$VINCS" =~ "$1" ]] || {
        source $1
        VINCS="$VINCS$1:"
    }
}

export -f include

base=(
$HOME/.bin/lib/lib.shell
$HOME/.bin/ini/ini.shell
)

for line in ${base[@]}; do
    if [ -f "$line" ]; then
        include "$line"
    fi
done

unset base

if [ -d "$VACCOUNT/$VHOSTID" ]; then
    add_path "$VACCOUNT/$VHOSTID"
    source "$VACCOUNT/$VHOSTID/init"
fi
