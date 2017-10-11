#!/bin/bash

generate_link() {
    #origin_list="
    origin_dir="$HOME/.local/.origin" # bak for old

    [ ! -d "$origin_dir" ] && mkdir -p "$origin_dir"

    for i in $(ls $PWD/src/dots -1); do
        [ -w "$HOME/.$i" ] && mv -f "$HOME/.$i" "$origin_dir"
        ln -s "$PWD/src/dots/$i" "$HOME/.$i"
    done
}

be_sudoer() {
    # sudoer check
    if [[ "$(cat /etc/group | sed -n '/^sudo:/p;')" =~ "$(whoami)" ]]; then
        [ ! -f '/etc/sudoers.d/vsudoer' ] && ln -s /home/user/.bin/local/vsudoer /etc/sudoers.d/vsudoer
        chown root /etc/sudoers.d/vsudoer
        chgrp root /etc/sudoers.d/vsudoer
    fi
}

#======================== MAIN

generate_link
source $HOME/.profile

be_sudoer

echo " done!"
