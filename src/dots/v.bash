#!/bin/bash

shopt -s expand_aliases

function include() {
    [[ "$VINCS" =~ "$1:" ]] || {
        source $1
        VINCS="$VINCS$1:"
    }
}

if [ -n "$ZSH" ]; then
    HOSTNAME="$HOST"
    export ZSH_EXPORTED_FUNCTIONS="$(functions include)"
else
    export -f include
fi

include $HOME/.bin/lib/lib.shell
include $HOME/.bin/ini/ini.shell.1

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
            rm "$HOME/.bin/user" > /dev/null
            ln -sf "$VACCOUNT/$VHOSTID" "$HOME/.bin/user"
            echo $listfile_md1 > "../.inited"
            echo reset - "$VHOSTID" done! >&2
        fi
    )
    # clean_invalid_ln "$VACCOUNT/$VHOSTID"
    [ -d "$VACCOUNT/$VHOSTID/bin" ] && add_path "$VACCOUNT/$VHOSTID/bin"

    for i in $(ls $HOME/.bin/lib); do
        complete -F complete_for_lib $i
    done
    [ -f "$VACCOUNT/$VHOSTID/init" ] && source "$VACCOUNT/$VHOSTID/init" "load"
fi

include $HOME/.bin/ini/ini.shell.2

[ -f "$HOME/.tmp_init" ] && include "$HOME/.tmp_init"
