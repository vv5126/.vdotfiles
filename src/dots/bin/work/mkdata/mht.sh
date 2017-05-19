#!/bin/bash

# for manhattan project

. ~/.bin/ini/ini.work
. ~/.bin/lib/lib.work
. ~/.bin/lib/lib.shdb

function make_info_file() {
        local file=$1
        local str="
	# [base]

        task_type=$task_type

	customer=$customer

	feature=$feature

	forBOARD=$forBOARD

	project_type=$project_type

        kernel_config=$KERNEL_BUILD_CONFIG
	kernel_image=$KERNEL_IMAGE_PATH/$KERNEL_TARGET_IMAGE

        uboot_config=$UBOOT_BUILD_CONFIG
	uboot_image=$UBOOT_TARGET_FILE

        the_img_dir=$the_img_dir

	# [opt]

	needclean=$needclean

	addtime=$addtime

	note=$note

	# [out]

	target_dir=$target_dir

	# [unuse]

        project_select=$project_select

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
        trap "rm -f .mht.sh .project_info; exit 2" 1 2 3 15

        get_project_base_info
        local project_target_dir="$HOME/work/$task_type/${customer:+$customer/}"
        local bool

        source build/envsetup.sh
        lunch
        [ $? -ne 0 ] && exit
        # [ -z $TARGET_PRODUCT ] && { echo 'need lunch the project frist!' >&2; exit; }
        mk2sh device/$TARGET_DEVICE/device.mk .tmp
        # sed -i "1i\TOPDIR=$PWD/" .tmp
        source .tmp; rm .tmp

        project_type=manhattan
        project_select=$TARGET_PRODUCT
        forBOARD=$TARGET_DEVICE

	git_remote=$(cd .repo/manifests; git remote -v | head -2 | tail -1 | awk '{print $2}')
	git_branch=$(cd .repo/manifests; git branch | grep '*' | awk '{print $2}')
        real_br="$(cd .repo/manifests; git branch -a | grep '\->' -)"

        the_img_dir=out/product/${forBOARD:+$forBOARD/}image
        target_dir='$VGL_BOARDS/$task_type/${customer:+$customer/}$feature'

	make_info_file ".project_info"

        # (cd kernel; source mk)
        # (cd u-boot; source mk)

        [ "$project_target_dir" != "$PWD" ] && {
            bool=$(get_input " Do you want move the project to \"$project_target_dir\"?\n please say \e[40;33m Yes\033[0m or \033[40;32m No\033[0m.")
            if [ "$bool" == 'y' ]; then
                mkdir -p "$project_target_dir"
                mv "$PWD" "$project_target_dir/$feature" && ln -s "$project_target_dir/$feature" ~
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
