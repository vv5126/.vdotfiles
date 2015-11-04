#!/bin/bash

function mk() {
	CONFIG=
	make clean && make  -j32 > .tmp && scp ./u-boot-with-spl-mbr-gpt.bin
	user@192.168.4.150:~/boards/mercury/u-boot-mercury5.1.bin
}

[ "$#" -gt 1 ] && {
	case "$1" in
	'init')
		;;
	'c')
		make clean	
		;;
	*)
		;;
	esac
}
