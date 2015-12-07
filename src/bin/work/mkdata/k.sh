#!/bin/bash

function mk() {

	source .project_info
	case "$forOS" in
	'android'*)
		[ "$addtime" = "1" ] && target_name=$target_name-$(date +%Y-%m-%d_%H:%M)
		[ -n "$note" ] && target_name=$target_name-$note
		target_name=$target_name.img
		[ "$needclean" = "1" ] && make clean
		[ -f $the_image ] && rm $the_image
		make zImage -j32
		if [ -f $the_image ]; then
			[ ! -d "build_bootimage" ] && cp -r $VGL_BUILD_ROOT_DIR ./build_bootimage
		   cd build_bootimage
		   bash m.sh
		fi
		;;
	'tizen'*)
		[ "$addtime" = "1" ] && target_name=$target_name-$(date +%Y-%m-%d_%H:%M)
		[ -n "$note" ] && target_name=$target_name-$note
		target_name=$target_name.img
		[ "$needclean" = "1" ] && make clean
		[ -f $the_image ] && rm $the_image
		make uImage -j32 && {
			echo the out img: $target_name >&2
			smkdir $target_dir
			scp $the_image $target_dir/$target_name
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

	tmp=$(user_select 'what Version' '3.10' '3.08')
	[ $? = 0 ] && project_type='kernel'$tmp
	git_remote=$(git remote -v | head -2 | tail -1 | awk '{print $2}')
	git_branch=$(git branch | grep '*' | awk '{print $2}')
	while read line; do
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

	tmp=$(user_select 'what OS' tizen23 tizen30 android51 android44)
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
