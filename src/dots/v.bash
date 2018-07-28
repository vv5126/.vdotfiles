#!/bin/bash

[[ $(ps -p $$ -o comm=) == 'zsh' ]] && HOSTNAME="$HOST"

function include() {
    [[ "$VINCS" =~ "$1:" ]] || {
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
    (
        cd "$VACCOUNT/$VHOSTID"

        if [ ! -f "../.inited" ]; then
            [ -f "init" ] && source "./init" "init"
            > "../.inited"
        fi

        listfile_md5="$(md5sum ln_list | awk '{print $1}')"
        if [ "x$(cat ../.inited)" != "x$listfile_md5" ]; then
            find $1 -type l -delete
            [ -f "ln_list" ] && lnn_file ln_list
            echo $listfile_md5 > "../.inited"
        fi
    )
    # clean_invalid_ln "$VACCOUNT/$VHOSTID"
    add_path "$VACCOUNT/$VHOSTID"
    [ -f "$VACCOUNT/$VHOSTID/init" ] && source "$VACCOUNT/$VHOSTID/init" "load"
fi
