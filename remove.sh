#!/bin/bash

origin_dir="$HOME/.local/.origin"

for i in $(ls $PWD/src/dots -1); do
    [ -w "$HOME/.$i" ] && rm -f "$HOME/.$i"
    [ -w "$origin_dir/.$i" ] && cp -r "$origin_dir/.$i" "$HOME"
done

rm $HOME/.bash_history 2>/dev/null
rm $HOME/.cdlist 2>/dev/null
rm $HOME/.viminfo 2>/dev/null
rm $HOME/.vim_mru_files 2>/dev/null
#rm -rf $HOME/.origin 2>/dev/null
rm -rf $HOME/.clipboard 2>/dev/null
#rm -rf $HOME/.rm 2>/dev/null
#rm -rf $HOME/.vdotfiles 2>/dev/null
