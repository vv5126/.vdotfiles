#!/bin/bash

. ~/.bin/ini/ini.work

function mk() {
    local new_target_name=
    local build_bootimage_tar=${VGL_BUILD_BOOTIMAGE##*\/}
    local build_bootimage_dir=${build_bootimage_tar%%.*}
	source .project_info
	case "$forOS" in
	'brillo'* | 'android'*)
		[ "$needclean" = "1" ] && make clean
		[ -f "$the_image" ] && rm $the_image
		make zImage -j32
		if [ -f $the_image ]; then
		    [ ! -d "$build_bootimage_dir" ] && {
                scp $VGL_BUILD_BOOTIMAGE .
                tar -xf $build_bootimage_tar && rm $build_bootimage_tar
            }
		    cd $build_bootimage_dir
		    bash m.sh && {
                new_target_name=$target_name
                [ "$addtime" = "1" ] && new_target_name=$target_name-$(date +%Y-%m-%d_%H:%M)
                [ -n "$note" ] && new_target_name=$new_target_name-$note
                new_target_name=$new_target_name.img
			    echo -e "\n  the out img: $new_target_name" >&2
			    smkdir $target_dir
			    scp "out/$target_name" $target_dir/$new_target_name
            }
		fi
		;;
	'tizen'*)
		[ "$needclean" = "1" ] && make clean
		[ -f "$the_image" ] && rm $the_image
		make uImage -j32 && {
            new_target_name=$target_name
            [ "$addtime" = "1" ] && new_target_name=$target_name-$(date +%Y-%m-%d_%H:%M)
            [ -n "$note" ] && new_target_name=$new_target_name-$note
            new_target_name=$new_target_name.img
			echo -e "\n  the out img: $new_target_name" >&2
			smkdir $target_dir
			scp $the_image $target_dir/$new_target_name
		}
		;;
	*)
		;;
	esac
}


function init(){
	local tmp=

	if [ ! -f ".config" ]; then
		ls arch/mips/configs
		echo -en "\n  please select a config  >>> ">&2
		read tmp
		[ -f "arch/mips/configs/$tmp" ] && cp arch/mips/configs/$tmp .config || return 1
	fi

	# tmp=$(user_select 'what Version' '3.10' '3.08')
	# [ $? = 0 ] && project_type='kernel'$tmp
	git_remote=$(git remote -v | head -2 | tail -1 | awk '{print $2}')
	git_branch=$(git branch | grep '*' | awk '{print $2}')
	while read line; do
		[[ $line =~ "Kernel Configuration" ]] && project_type="kernel$(echo "$line" | cut -d " " -f 3)"
		[[ "$line" =~ "CONFIG_BOARD_NAME" ]] && forBOARD=${line##*=}
		[[ "$line" =~ "CONFIG_PRODUCT_NAME" ]] && platfrom_name=${line##*=}
		if [[ "$line" =~ "CONFIG_LCD_" ]] && [ "${line:0-1}" = "y" ]; then
			[[ "$line" =~ "CONFIG_LCD_CLASS_DEVICE" ]] || {
				tmp=${line#*CONFIG_LCD_}
				lcd_name=${tmp%=*}
				break
			}
		fi
	done < ".config"
	target_dir='$VGL_BOARDS/$forBOARD-$forOS-imgs'
	target_name='$project_type-$forBOARD-$forOS'

	tmp=$(user_select 'what OS' "${surport_os[@]}")
	[ $? = 0 ] && forOS=$tmp

	case $forOS in
	'android'*)
		the_image=arch/mips/boot/zcompressed/zImage
		;;
	'tizen'*)
		the_image=arch/mips/boot/uImage
		;;
	'buildroot'*)
		the_image=
		;;
	esac

	repositories_type='git'
	make_info_file
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
		make distclean
		;;
	*)
		;;
	esac
} || {
	mk
}
