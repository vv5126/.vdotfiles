#!/bin/bash -

bundle=/backup/home/wgao/.local/vdot/dots/vim/bundle
bakDir="~/.vim/patchs"

function bak() {
    cd $bundle

    list="$(ls)"
    for i in ${list[@]}; do
        [ -d "$i" ] && (
        cd ./$i
        # git remote -v >> ../a
        git diff > ../"$i"-test
        [ "$(stat -c "%s" ../"$i"-test)" -eq 0 ] && rm ../"$i"-test
    )
done
eval mv "$bundle/*-test" $bakDir
}

function store() {
    cd $bakDir

    list="$(ls)"
    for i in ${list[@]}; do
        repo=${i%-*}
        [ -d "$bundle/$repo" ] && (
            cd $bundle/$repo
            patch -p1 < $bakDir/$i
        )
    done

    patchs="$(ls $patch_dir)"

    for (( i = 0; i < ${#patchs[@]}; i++ )); do
        $(cd ${i%-*}; patch -p1 < $patch_dir/$i)
    done
}
