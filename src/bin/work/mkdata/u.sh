#!/bin/bash


function mk() {

	source .project_info
	case "$forOS" in
	'android')
		[ $needclean = "1" ] && make clean
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
		make $board_config -j32 > .tmp && {
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

	project_type='uboot'
	git_remote=$(git remote -v | head -2 | tail -1 | awk '{print $2}')
	git_branch=$(git branch | grep '*' | awk '{print $2}')
	target_dir='$VGL_BOARDS/$forBOARD-$forOS-imgs'
	target_name='$project_type-$forBOARD-$forOS-$board_config'

	tmp=$(user_select 'what OS' tizen23 tizen30 android51 android44)
	[ $? = 0 ] && forOS=$tmp

	case $forOS in
	'android'*)
		the_image=
		;;
	'tizen'*)
		the_image=u-boot-with-spl.bin
		;;
	'buildroot'*)
		the_image=
		;;
	esac

	repositories_type='git'
	make_info_file
	return 0
}


[ "$#" -ge 1 ] && {
	case "$1" in
	'init')
		init
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
