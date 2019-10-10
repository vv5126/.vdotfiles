#!/bin/bash

# for android project

include work
include shdb

function make_info_file() {
        local file=$1
        local str="
	# [base]

        task_type=$task_type

	customer=$customer

	feature=$feature

	forBOARD=$forBOARD

	project_type=android

        the_img_dir=$the_img_dir

	# [opt]

	needclean=$needclean

	addtime=$addtime

	note=$note

	# [out]

	target_dir=$target_dir

	# [unuse]

	repositories_type=repo

	git_remote=$git_remote

	git_branch=$git_branch

        # $real_br
        "
        shdb -f "$file" -a "$str"
}


function mkmain() {
	source .project_info
        [ "$needclean" = "1" ] && make clean

        make && {
            echo -e "\n  the out img dir: $target_dir" >&2
            smkdir "$target_dir"
            scp -r "$the_img_dir" "$target_dir"
        }
}


function init() {
        trap "rm -f .a.sh .project_info; exit 2" 1 2 3 15

        get_project_base_info
        local project_target_dir="$HOME/work/$task_type/$customer"
        local bool

        source build/envsetup.sh
        lunch
        [ $? -ne 0 ] && exit 255

        forBOARD=$TARGET_PRODUCT

	git_remote=$(cd .repo/manifests; git remote -v | head -2 | tail -1 | awk '{print $2}')
	git_branch=$(cd .repo/manifests; git branch | grep '*' | awk '{print $2}')
        real_br="$(cd .repo/manifests; git branch -a | grep '\->' -)"

        the_img_dir=out/target/product/${forBOARD:+$forBOARD/}image
        [ -n "$customer" ] && target_dir='$VGL_BOARDS/$task_type/$customer/$feature' || target_dir='$VGL_BOARDS/$task_type/$feature'

	make_info_file ".project_info"

        [ "$project_target_dir" != "$PWD" ] && {
            bool=$(get_input " Do you want move the project to \"$project_target_dir\"?\n please say \e[40;33m Yes\033[0m or \033[40;32m No\033[0m.")
            if [ "$bool" == 'y' ]; then
                mkdir -p "$project_target_dir"
                mv "$PWD" "$project_target_dir/$feature" && cd "$project_target_dir/$feature"
                echo the project has move to "$project_target_dir/$feature" >&2
            fi
        }

	return 0
}

[ "$#" -ge 1 ] && {
	case "$1" in
	'init')
		init
		;;
	'c')
		make clean
		;;
	*)
		;;
	esac
} || {
	mkmain
}

shdb_format ".project_info" &
