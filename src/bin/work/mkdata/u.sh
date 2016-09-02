#!/bin/bash


function mk() {

	source .project_info
	case "$forOS" in
	*)
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
		;;
	esac
}


function init(){
	local tmp=

	project_type='uboot'
	git_remote=$(git remote -v | head -2 | tail -1 | awk '{print $2}')
	git_branch=$(git branch | grep '*' | awk '{print $2}')
	target_dir='$VGL_BOARDS/$forBOARD_$forOS-imgs'
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
	mk
}
