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

#======================== MAIN

generate_link
echo '[ -z "$VHOSTID" -a -f ~/.v.bash ] && source ~/.v.bash' >> ~/.bashrc
[ -f "$VACCOUNT/.inited" ] && rm "$VACCOUNT/.inited"

source $HOME/.profile

echo " done!"
