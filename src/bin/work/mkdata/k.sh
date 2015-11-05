#!/bin/bash

function mk() {
	forwhat=tizen
	needclean=0


	if [ $forwhat = "android" ]; then
		ZIMAGE=arch/mips/boot/zcompressed/zImage
		[ -f $ZIMAGE ] && rm $ZIMAGE
		make zImage -j32
		if [ -f $ZIMAGE ]; then
		   cd build_bootimage
		   bash m.sh
		fi
	else
		[ $needclean = "1" ] && make clean
		make  -j32 > .tmp && scp ./u-boot-with-spl-mbr-gpt.bin
		user@192.168.4.150:~/boards/mercury/u-boot-mercury5.1.bin
	fi


	OUT_IMAGE=tizen23-aw808-kernel310-$(date +%Y-%m-%d_%H:%M).img
	#OUT_IMAGE=tizen23-inwatch-kernel310-$(date +%Y-%m-%d_%H:%M).img

	make uImage -j32

	echo the out img: $OUT_IMAGE
	scp arch/mips/boot/uImage user@192.168.4.150:/home/user/boards/tizen23-aw808-imgs/$OUT_IMAGE
	#scp arch/mips/boot/uImage user@192.168.4.150:/home/user/boards/tizen23-inwatch-imgs/$OUT_IMAGE
}


function init(){
	project_type='kernel'
	git_remote=$(git remote -v | head -2 | tail -1 | awk '{print $2}')
#	git_branch=$(git branch -v | head -2 | tail -1 | awk '{print $2}')
	while read line; do
		[[ "$line" =~ "CONFIG_BOARD_NAME" ]] && board_name=${line##*=}
		[[ "$line" =~ "CONFIG_PRODUCT_NAME" ]] && product_name=${line##*=}
		if [[ "$line" =~ "CONFIG_LCD_" ]] && [ "${line:0-1}" = "y" ]; then
			[[ "$line" =~ "CONFIG_LCD_CLASS_DEVICE" ]] || {
				tmp=${line#*CONFIG_LCD_}
				lcd_name=${tmp%=*}
				break
			}
		fi
	done < ".config"
	target_dir=$VGL_BOARDS
	target_name=

	local haha
	haha=$(user_select sjdif asdfi asaa sadf)
	echo $haha >&2

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
		if [ "${1:0-2}" == ".c" ]; then
			make_i $1
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
