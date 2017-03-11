#!/bin/bash


function mk() {
	make clean && make -j32 && scp fImage fpga@192.168.4.13:"/home/fpga/user/wgao/fpga/t10_lcd/f-Image"
}

[ "$#" -gt 1 ] && {
	case "$1" in
	'init')
		;;
	'c')
		make clean
		;;
        'ycm_conf')
                make clean
                make -n -j32 > .tmp 2>&1
                ycmadd .tmp
                rm .tmp
                ;;
	*)
		;;
	esac
} || {
	mk
}
