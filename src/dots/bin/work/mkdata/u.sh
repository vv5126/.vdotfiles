#!/bin/bash

. ~/.bin/ini/ini.work
. ~/.bin/lib/lib.work
. ~/.bin/lib/lib.shdb

debug=1

function get_repo_dir() {
    repo_info=''
    local repo_dir="$(getdir .repo)"
    [ -n "$repo_dir" -a -f "$repo_dir/.project_info" ] && repo_info="$repo_dir/.project_info"
}

function make_info_file(){
        local file=$1
        local str="
	# [base]

	summary=

	customer=$customer

	forOS=$forOS

	forBOARD=$forBOARD

	project_type='uboot'

	the_image=$the_image

	board_config=$board_config

	# [opt]

	needclean=$needclean

	addtime=$addtime

	note=$note

	# [out]

	target_dir=$target_dir

	target_name=$target_name

	# [unuse]

	repositories_type='git'

	git_remote=$git_remote

	git_branch=$git_branch
        "
        shdb -f "$file" -a "$str"
}

function mkmain() {

        [ -f ".project_info" ] && source .project_info
        [ "$addtime" = "1" ] && target_name=$target_name-$(date +%Y-%m-%d_%H:%M)
        [ -n "$note" ] && target_name=$target_name-$note
        target_name=$target_name.img
        [ "$needclean" = "1" ] && make distclean
        [ -f $the_image ] && rm $the_image
        make $board_config -j32 > .tmp && {
            echo the out img: $target_dir/$target_name >&2
            smkdir $target_dir
            scp $the_image $target_dir/$target_name
        }
}


function init(){
	local tmp=

        get_repo_dir

        if [ -n "$repo_info" ]; then
            source $repo_info
        else
            get_project_base_info
            local project_target_dir="$HOME/work/$task_type/$customer"
            local bool

            [ "$project_target_dir" != "$PWD" ] && {
                bool=$(get_input " Do you want move the project to \"$project_target_dir\"?\n please say \e[40;33m Yes\033[0m or \033[40;32m No\033[0m.")
                if [ "$bool" == 'y' ]; then
                    mkdir -p "$project_target_dir"
                    mv "$PWD" "$project_target_dir/uboot_$feature" && cd "$project_target_dir/uboot_$feature"
                    echo the project has move to "$project_target_dir/uboot_$feature"
                fi
            }
        fi

        if [ -n "$uboot_config" ]; then
            board_config=$uboot_config
            the_image="$uboot_image"
        fi

        if [ -z "$forOS" ]; then
	    tmp=$(user_select 'what OS' "${surport_os[@]}")
            forOS="${tmp:=none}"

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
        fi

	git_remote="$(git remote -v | head -2 | tail -1 | awk '{print $2}')"
	git_branch="$(git branch | grep '*' | awk '{print $2}')"
        if [[ "$git_branch" =~ '(' ]]; then
            tmp=$(git branch -a | grep -o '\->.*$')
            git_branch=${tmp##*/}
        fi

	target_dir='$VGL_BOARDS/$forBOARD_$forOS-imgs'
	target_name='$uboot-$forBOARD-$forOS-$board_config'

	make_info_file ".project_info"
	return 0
}

function mk_data_file() {
        local dir
        > data_tag
        while read line; do
                [[ "$line" =~ "Entering directory" ]] && { dir="${line#* \`}"; echo $dir; continue; }
                for i in ${line[@]}; do
                        # echo $dir
                        [ "${i:0-2}" == '.c' ] && echo $dir/$i >> data_tag
                        [ "${i:0-2}" == '.S' ] && echo $dir/$i >> data_tag
                done
        done < $1

        while read line; do
                find $line >> data_tag
        done < $2
}

function mk_h_file() {
        local temp
        while read line; do
                for i in ${line[@]}; do
                        [ "${i:0:2}" == '-I' ] && {
                                [[ "$temp" =~ "$i" ]] || temp=${i:2}
                }
                done
        done < $1
        echo $temp > data_h
}

function mk_gcc_file() {
        sed -i ':a;N;$ s/\\\n/ /g;ba' $1
        sed -i 's/;/\n/g' $1
        sed -i "s/'/\n/g" $1
        sed -i 's/\t/ /g' $1
        sed -i 's/  */ /g' $1
        sed -i '/^\s/s/\s//' $1
        sed -i '/^mips-linux-gnu-gcc\|Entering directory/!d' $1
        # sed -i '/^mips-linux-gnu-gcc\|^gcc/!d' $1
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
		make distclean
		make $board_config -j1 > .tmp 2>&1
                # cp .tmp ttt
                mk_gcc_file .tmp
                mk_h_file .tmp
                mk_data_file .tmp data_h
                # ycmadd .tmp
                # rm .tmp
                ;;
	*)
		;;
	esac
} || {
	mkmain
}

shdb_format ".project_info" &
