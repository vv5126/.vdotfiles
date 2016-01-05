#!/bin/bash

function mk() {
	if [ $# -gt 0 ];then
		if [ $1 == "all" ]; then
			gbs -v build -A mipsel --include-all --overwrite 2>&1|tee build.log
		else
			gbs -v build -A mipsel --include-all --overwrite $1 2>&1|tee build.log
            if [ $? = 0 ]; then
                cd -
                . ./.project_info
                [ ! -d "out" ] && mkdir out
                cp -f $(find ~/GBS-ROOT -name $target_name) ./out 2>/dev/null
                cd out
                unrpm $target_name
            fi
		fi
	fi
}

function init(){
    local value=

	forOS='tizen23'
	repositories_type='git'
	git_remote=$(git remote -v | head -2 | tail -1 | awk '{print $2}')
	git_branch=$(git branch | grep '*' | awk '{print $2}')
	# target_dir='$VGL_BOARDS/$forBOARD-$forOS-imgs'

    while read line; do
        if [[ "$line" =~ "Name:" ]]; then
            value=$value${line##* }
        fi
        if [[ "$line" =~ "Version:" ]]; then
            value=$value-${line##* }
        fi
        if [[ "$line" =~ "Release:" ]]; then
            value=$value-${line##* }
            break
        fi
    done < "$(find ./packaging -name *.spec)"
    [ -n "$value" ] && target_name="$value.mipsel.rpm"

	make_info_file
	return 0
}

[ "$#" -ge 1 ] && {
	case "$1" in
	'init')
		init
		;;
	'all')
		mk all
		;;
	*)
		;;
	esac
} || {
    tizen_base_dir=`getdir_project | awk '{print $2}'`
    cd $tizen_base_dir
    mk $OLDPWD
}
