#!/bin/bash

generate_link() {
    #origin_list="
    origin_dir="$HOME/.local/.origin"

    [ ! -d "$origin_dir" ] && mkdir -p "$origin_dir"

    for i in $(ls $PWD/src/dots -1); do
        [ -w "$HOME/.$i" ] && mv -f "$HOME/.$i" "$origin_dir"
        ln -s "$PWD/src/dots/$i" "$HOME/.$i"
    done
}

sync_repo() {
    [ ! -e "$1" ] && { mkdir -p "$1"; git clone -b "$3" "$2" "$1"; } || { cd "$1" && git pull origin "$3"; }
}

vim_init() {
    REPO_BRANCH='3.0'
    sync_repo   "$HOME/.vim/bundle/spf13-vim" 'https://github.com/spf13/spf13-vim.git' "$REPO_BRANCH" "spf13-vim"
    sync_repo   "$HOME/.vim/bundle/vundle" 'https://github.com/gmarik/vundle.git' "master" "vundle"
    vim -u      "$HOME/.vimrc" "+set nomore" "+BundleInstall!" "+qall"
    # vim -u      "$HOME/.vimrc" "+set nomore" "+BundleInstall!" "+BundleClean" "+qall"
}

be_sudoer() {
    [ ! -f '/etc/sudoers.d/vsudoer' ] && ln -s /home/user/.bin/local/vsudoer /etc/sudoers.d/vsudoer
    chown root /etc/sudoers.d/vsudoer
    chgrp root /etc/sudoers.d/vsudoer
}

#======================== MAIN

# be_sudoer
# generate_link
vim_init
echo " done!"
