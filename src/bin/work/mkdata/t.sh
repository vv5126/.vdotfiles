#!/bin/bash

function mk() {
	if [ $# -gt 0 ];then
		if [ $1 == "all" ]; then
			gbs -v build -A mipsel --include-all --overwrite 2>&1|tee build.log
		else
			gbs -v build -A mipsel --include-all --overwrite $1 2>&1|tee build.log
		fi
	fi
}

[ "$#" -gt 1 ] && {
	case "$1" in
	'init')
		;;
	'all')
		mk all
		;;
	'')
		if [ ! -d '.repo' ]; then
	#		if [ ! -d '.git' ]; then
				tizen_base_dir=`getdir_project | awk '{print $2}'`
				tizen_module_dir=`getdir_git | awk '{print $2}'`
				cd $tizen_base_dir; ./t.sh $tizen_module_dir
	#		fi
		fi
		;;
	*)
		;;
	esac
}
