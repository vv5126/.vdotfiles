#!/bin/bash

[[ $(ps -p $$ -o comm=) == 'zsh' ]] && HOSTNAME="$HOST"

function include() {
    [[ "$VINCS" =~ "$1:" ]] || {
        source $1
        VINCS="$VINCS$1:"
    }
}

if [[ "$(ps -p $$ -o comm=)" == 'zsh' ]]; then
    export ZSH_EXPORTED_FUNCTIONS="$(functions include)"
else
    export -f include
fi

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
        include $VLIBS/lib.misc
        cd "$VACCOUNT/$VHOSTID"

        if [ ! -f "../.inited" ]; then
            [ -f "init" ] && source "./init" "init"
            > "../.inited"
        fi

        listfile_md1="$(md1sum ln_list | awk '{print $1}')"
        if [ "x$(cat ../.inited)" != "x$listfile_md1" ]; then
            find $1 -type l -delete
            [ -f "ln_list" -a -d "bin" ] && (cd bin; lnn_file ../ln_list)
            echo $listfile_md1 > "../.inited"
            echo reset - "$VHOSTID" done! >&2
        fi
    )
    # clean_invalid_ln "$VACCOUNT/$VHOSTID"
    [ -d "$VACCOUNT/$VHOSTID/bin" ] && add_path "$VACCOUNT/$VHOSTID/bin"
    [ -f "$VACCOUNT/$VHOSTID/init" ] && source "$VACCOUNT/$VHOSTID/init" "load"
fi
