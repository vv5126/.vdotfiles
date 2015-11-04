#!/bin/bash

function init(){
	project_type='uboot'
	git_remote=$(git remote -v | head -2 | tail -1 | awk '{print $2}')
#	git_branch=$(git branch -v | head -2 | tail -1 | awk '{print $2}')
	board_config=
	final_bin=u-boot-with-spl.bin
	target_dir=$VGL_BOARDS
	target_name="$project_type"-"\$board_config".bin

	make_info_file
	return 0
}
function mk() {
	CONFIG=
	make clean && make  -j32 > .tmp && scp ./u-boot-with-spl-mbr-gpt.bin
	user@192.168.4.150:~/boards/mercury/u-boot-mercury5.1.bin
}

[ "$#" -ge 1 ] && {
	case "$1" in
	'init')
		init
		;;
	'')
		mk
		;;
	*)
		;;
	esac
}
