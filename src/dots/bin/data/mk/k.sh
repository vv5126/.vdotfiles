#!/bin/bash

include $VINIS/ini.work
include $VLIBS/lib.work
include $VLIBS/lib.shdb

debug=0

function get_repo_dir() {
    repo_info=''
    local repo_dir="$(getdir .repo)"
    [ -n "$repo_dir" -a -f "$repo_dir/.pro/project_info" ] && repo_info="$repo_dir/.pro/project_info"
}

function make_info_file(){
        local file=$1
        local str="
	# [base]

        task_type=$task_type

	customer=$customer

	feature=$feature

	forOS=$forOS

	forBOARD=$forBOARD

	project_type=$project_type

	the_image=$the_image

	lcd_name=$lcd_name

	board_config=$board_config

        date="$(date +%Y%m%d_%H%M)"

	# [opt]

	needclean=$needclean

	addtime=$addtime

	note=$note

	# [out]

	target_dir=$target_dir

	target_name=$target_name

	# [unuse]

	repositories_type='git'

	git_remote=$git_remote

	git_branch=$git_branch
        "
        shdb -f "$file" -a "$str"
}


function mkmain() {
    local new_target_name=
    local build_bootimage_tar=${VGL_BUILD_BOOTIMAGE##*\/}
    local build_bootimage_dir=${build_bootimage_tar%%.*}

    # [ ! -f ".pro/project_info" -a -n "$repo_info" ] && source $repo_info
    [ -f ".pro/project_info" ] && source .pro/project_info
    # [ "$use_repo" -eq 1 -a -n "$repo_info" ] && source $repo_info
    # the_image=$KERNEL_IMAGE_PATH/$KERNEL_TARGET_IMAGE

        [ "$needclean" = "1" ] && make clean
        [ -f "$the_image" ] && rm $the_image
	case "${the_image##*/}" in
	'xImage')
		make xImage -j32
		;;
	'zImage')
		make zImage -j32
		;;
	'uImage')
		make uImage -j32
		;;
	esac

	if [ -f $the_image ]; then
	    case "$forOS" in
                'android'*)
                    [ ! -d "$build_bootimage_dir" ] && {
                    scp $VGL_BUILD_BOOTIMAGE .
                    tar -xf $build_bootimage_tar && rm $build_bootimage_tar
                }
                (
                cd $build_bootimage_dir
                bash m.sh && {
                    new_target_name=$target_name
                    [ "$addtime" = "1" ] && new_target_name=$target_name-$(date +%Y-%m-%d_%H:%M)
                    [ -n "$note" ] && new_target_name=$new_target_name-$note
                    new_target_name=$new_target_name.img
                    echo -e "\n  the out img: $target_dir/$new_target_name" >&2
                    smkdir $target_dir
                    scp "out/$target_name" $target_dir/$new_target_name
                }
                )
            ;;
        *)
            if [ -n "$the_img_dir" ]; then
                echo -e "\n  the out img: $the_img_dir" >&2
                smkdir $the_img_dir
                scp $the_image $the_img_dir
            else
                new_target_name=$target_name
                [ "$addtime" = "1" ] && new_target_name=$target_name-$(date +%Y-%m-%d_%H:%M)
                [ -n "$note" ] && new_target_name=$new_target_name-$note
                new_target_name=$new_target_name.img
                echo -e "\n  the out img: $target_dir/$new_target_name" >&2
                smkdir $target_dir
                scp $the_image $target_dir/$new_target_name
            fi
            ;;
    esac
	fi
}


function init(){
        trap "rm -rf .pro; exit 2" 1 2 3 15

	local tmp=

        get_repo_dir

        if [ -n "$repo_info" ]; then
            debug echo source $repo_info
            source $repo_info
        else
            get_project_base_info
            local project_target_dir="$HOME/work/$task_type/$customer"
            local bool

            [ "$project_target_dir" != "$PWD" ] && {
                bool=$(get_input " Do you want move the project to \"$project_target_dir\"?\n please say \e[40;33m Yes\033[0m or \033[40;32m No\033[0m.")
                if [ "$bool" == 'y' ]; then
                    mkdir -p "$project_target_dir"
                    mv "$PWD" "$project_target_dir/kernel_$feature" && ln -s "$project_target_dir/kernel_$feature" ~
                    echo the project has move to "$project_target_dir/kernel_$feature"
                fi
            }
        fi

        if [ -n "$kernel_config" ]; then
           forOS=$project_type
           board_config=$kernel_config
           the_image="$kernel_image"
           make $kernel_config
        elif [ ! -f ".config" ]; then
		ls arch/mips/configs
		echo -en "\n  please select a config  >>> ">&2
		read tmp
		[ -f "arch/mips/configs/$tmp" ] && { cp arch/mips/configs/$tmp .config; board_config=$tmp; } || return 1
	fi

        if [ -f ".config" ]; then
            forBOARD="$(sed -n '/CONFIG_BOARD_NAME/{s/.*=//;p;}' .config)"
            while read line; do
                [[ $line =~ "Kernel Configuration" ]] && project_type="kernel$(echo "$line" | cut -d " " -f 3)"
                # [[ "$line" =~ "CONFIG_BOARD_NAME" ]] && forBOARD=${line##*=}
                if [[ "$line" =~ "CONFIG_LCD_" ]] && [ "${line:0-1}" = "y" ]; then
                    [[ "$line" =~ "CONFIG_LCD_CLASS_DEVICE" ]] || {
                        tmp=${line#*CONFIG_LCD_}
                        lcd_name=${tmp%=*}
                        break
                    }
                fi
            done < ".config"
        fi

        if [ -z "$forOS" ]; then
            local surport_os="$(jsonparser --get_keys -k 'surport_os' -f $VGL_JSON_FILE)"
            tmp=$(user_select 'what OS' "${surport_os[@]}")
            forOS="${tmp:=none}"

            the_image="$(jsonparser --get_key -k "kernel_img $project_type" -f $VGL_JSON_FILE)"
            # case $project_type in
            #     'kernel3.0.8')
            #         the_image=arch/mips/boot/compressed/uImage
            #         ;;
            #     'kernel3.10.14')
            #         the_image=arch/mips/boot/uImage
            #         ;;
            # esac

            [ -z "the_image" ] && the_image="$(jsonparser --get_key -k "kernel_img $forOS" -f $VGL_JSON_FILE)"
            # case $forOS in
            #     'android'*)
            #         the_image=arch/mips/boot/zcompressed/zImage
            #         ;;
            #     'mozart'*)
            #         the_image=arch/mips/boot/zcompressed/xImage
            #         ;;
            #     'tizen'*)
            #         the_image=arch/mips/boot/uImage
            #         ;;
            #     'buildroot'*)
            #         the_image=
            #         ;;
            # esac
        fi

	git_remote="$(git remote -v | head -2 | tail -1 | awk '{print $2}')"
	git_branch="$(git branch | grep '*' | awk '{print $2}')"
        if [[ "$git_branch" =~ '(' ]]; then
            tmp=$(git branch -a | grep -o '\->.*$')
            git_branch=${tmp##*/}
        fi

	target_name='$project_type-$forBOARD-$forOS'
        [ -z "$target_dir" ] && target_dir='$VGL_BOARDS/$task_type/${customer:+$customer/}$forBOARD-$forOS-${feature%%_*}-imgs'

	make_info_file ".pro/project_info"
	return 0
}


function make_i() {
	local name=${1%.*}
	local line=
	echo name $name
	local cmd="."$name".o.cmd"
	echo cmd $cmd
	[ -f "$cmd" ] && read line < $cmd
	local gcc=${line##*:= }
	gcc="$gcc"' --save-temps'
	echo $gcc
	exit 0
	cd $PROJECT_DIR
	pwd
	$gcc
	[ $? = 0 ] && {
		[ -f "$name.i" ] && {
			cd -
			mv "$PROJECT_DIR/$name.i" "$PROJECT_DIR/$name.s" .
		}
	}
}

function mk_data_file() {
        local dir
        > data_tag
        while read line; do
                for i in ${line[@]}; do
                        [ "${i:0-2}" == '.c' ] && echo $i >> data_tag
                        [ "${i:0-2}" == '.S' ] && echo $i >> data_tag
                done
        done < $1

        while read line; do
                find $line >> data_tag
        done < $2
}

function clean_start_with() {
        sed -i "/^$1/d" $2

}

function mk_gcc_file() {
    cmd_files="$(find -name '*.o.cmd' | sed -n '/built-in.o.cmd$/!p;')"
    # o_files="$(find -name '*.o' | sed -n '/built-in.o$/!p;' | sed -n 's/o$/c/p;')"
    # echo $cmd_files > $1
    > $1
    for i in $cmd_files; do
        echo $(head -n 1 $i) >> $1
    done

        # sed -i ':a;N;$ s/\\\n/ /g;ba' $1
        # sed -i 's/;/\n/g' $1
        # sed -i "s/\"//g" $1
        # sed -i 's/\t/ /g' $1
        # sed -i 's/  */ /g' $1
        # sed -i '/^\s/s/\s//' $1
        # sed -i '/^mips-linux-gnu-gcc/!d' $1

        # sed -i '/^mips-linux-gnu-gcc\|^gcc/!d' $1
}

[ "$#" -ge 1 ] && {
	case "$1" in
	'init')
		init
		;;
	'm')
		make menuconfig
		;;
	'cfg')
		if [ $# -eq 2 ]; then
			ls -1 arch/mips/configs | grep "$2"
		else
			ls -1 arch/mips/configs
		fi
#			ls -l arch/mips/configs | grep ^[^d] | awk '{print $9}'
		;;
	'i')
		if [ "${2:0-2}" == ".c" ]; then
			make_i $2
		fi
		;;
	'c')
		make clean
		;;
	't')
                [ -f '.tagfile' ] && ctags -L .tagfile || echo failed!
		;;
        'ycm_conf')
                mkdir .tag
                mk_gcc_file .tag/gcc
                get_c_from_gcc .tag/gcc > .tag/c
                get_h_from_c .tag/c > .tag/h
                get_include_from_gcc .tag/gcc > .tag/include
                clean_duplicate_lines .tag/include
                get_h_from_include .tag/include >> .tag/h
                cat .tag/c .tag/h > .tag/fortag
                clean_duplicate_lines .tag/fortag
                ctags -L .tag/fortag
                # ycmadd file_include
                ;;
	*)
		;;
	esac
} || {
	mkmain
}

shdb_format ".pro/project_info" &
