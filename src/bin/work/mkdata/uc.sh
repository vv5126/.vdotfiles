#!/bin/bash


function mk() {

	source .project_info
	case "$forOS" in
	*)
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
	esac
}


function init(){

	project_type='ucos'
	forOS='ucos'
    board_config='fpga_x1000'

	repositories_type='git'
	git_remote=$(git remote -v | head -2 | tail -1 | awk '{print $2}')
	git_branch=$(git branch | grep '*' | awk '{print $2}')

	target_dir='$VGL_BOARDS/$forBOARD_$forOS-imgs'
	target_name='$project_type-$forBOARD-$forOS-$board_config'

	the_image=bin/uImage

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
    'ycm_conf')
	    source .project_info
        make clean
		make $board_config -n -j32 > .tmp 2>&1
        ycmadd .tmp
        rm .tmp
        ;;
	*)
		;;
	esac
} || {
	mk
}
