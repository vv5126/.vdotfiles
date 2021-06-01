#!/bin/bash -

bundle=/backup/home/wgao/.local/vdot/dots/vim/bundle
bakDir="$HOME/.vim/patchs"

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
    # cd $bakDir

    # list="$(ls)"
    # for i in ${list[@]}; do
    #     repo=${i%-*}
    #     [ -d "$bundle/$repo" ] && (
    #         echo cd $bundle/$repo
    #         cd $bundle/$repo
    #         echo patch -p1 < $bakDir/$i
    #         patch -p1 < $bakDir/$i
    #         # git apply $bakDir/$i
    #     )
    # done

    patchs="$(ls $bakDir)"

    cd $bundle
    for i in ${patchs[@]}; do
        echo cd ${i%-*}
        echo "patch -p1 < $bakDir/$i"
        (cd ${i%-*}; patch -p1 < $bakDir/$i)
    done
}

bak
# store
