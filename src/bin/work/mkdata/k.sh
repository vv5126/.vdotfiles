#!/bin/bash

. ~/.bin/ini/ini.work

function mk() {
    local new_target_name=
    local build_bootimage_tar=${VGL_BUILD_BOOTIMAGE##*\/}
    local build_bootimage_dir=${build_bootimage_tar%%.*}
	source .project_info
        [ "$needclean" = "1" ] && make clean
        [ -f "$the_image" ] && rm $the_image
	case "$forOS" in
	'brillo'* | 'android'*)
		make zImage -j32
		if [ -f $the_image ]; then
		    [ ! -d "$build_bootimage_dir" ] && {
                scp $VGL_BUILD_BOOTIMAGE .
                tar -xf $build_bootimage_tar && rm $build_bootimage_tar
            }
		    cd $build_bootimage_dir
		    bash m.sh && {
                        new_target_name=$target_name
                        [ "$addtime" = "1" ] && new_target_name=$target_name-$(date +%Y-%m-%d_%H:%M)
                        [ -n "$note" ] && new_target_name=$new_target_name-$note
                        new_target_name=$new_target_name.img
                        echo -e "\n  the out img: $target_dir/$new_target_name" >&2
                        smkdir $target_dir
                        scp "out/$target_name" $target_dir/$new_target_name
            }
		fi
		;;
	'tizen'*)
		make uImage -j32 && {
                    new_target_name=$target_name
                    [ "$addtime" = "1" ] && new_target_name=$target_name-$(date +%Y-%m-%d_%H:%M)
                    [ -n "$note" ] && new_target_name=$new_target_name-$note
                    new_target_name=$new_target_name.img
                    echo -e "\n  the out img: $target_dir/$new_target_name" >&2
                    smkdir $target_dir
                    scp $the_image $target_dir/$new_target_name
		}
		;;
	'NOS')
		make uImage -j32 && {
                        new_target_name=$target_name
                        [ "$addtime" = "1" ] && new_target_name=$target_name-$(date +%Y-%m-%d_%H:%M)
                        [ -n "$note" ] && new_target_name=$new_target_name-$note
                        new_target_name=$new_target_name.img
			echo -e "\n  the out img: $target_dir/$new_target_name" >&2
			smkdir $target_dir
                        scp $the_image $target_dir/$new_target_name
		        # vcp $the_image 
		}
		;;
	*)
		;;
	esac
}


function init(){
	local tmp=

	if [ ! -f ".config" ]; then
		ls arch/mips/configs
		echo -en "\n  please select a config  >>> ">&2
		read tmp
		[ -f "arch/mips/configs/$tmp" ] && { cp arch/mips/configs/$tmp .config; board_config=$tmp; } || return 1
	fi

	# tmp=$(user_select 'what Version' '3.10' '3.08')
	# [ $? = 0 ] && project_type='kernel'$tmp
	git_remote=$(git remote -v | head -2 | tail -1 | awk '{print $2}')
	git_branch=$(git branch | grep '*' | awk '{print $2}')
	while read line; do
		[[ $line =~ "Kernel Configuration" ]] && project_type="kernel$(echo "$line" | cut -d " " -f 3)"
		[[ "$line" =~ "CONFIG_BOARD_NAME" ]] && forBOARD=${line##*=}
		[[ "$line" =~ "CONFIG_PRODUCT_NAME" ]] && platfrom_name=${line##*=}
		if [[ "$line" =~ "CONFIG_LCD_" ]] && [ "${line:0-1}" = "y" ]; then
			[[ "$line" =~ "CONFIG_LCD_CLASS_DEVICE" ]] || {
				tmp=${line#*CONFIG_LCD_}
				lcd_name=${tmp%=*}
				break
			}
		fi
	done < ".config"
	target_dir='$VGL_BOARDS/$forBOARD-$forOS-imgs'
	target_name='$project_type-$forBOARD-$forOS'

	tmp=$(user_select 'what OS' "${surport_os[@]}")
	[ $? = 0 ] && forOS=$tmp

	case $forOS in
	'android'*)
		the_image=arch/mips/boot/zcompressed/zImage
		;;
	'tizen'*)
		the_image=arch/mips/boot/uImage
		;;
	'buildroot'*)
		the_image=
		;;
	esac

	repositories_type='git'
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

function mk_data_file() {
        local dir
        > data_tag
        while read line; do
                for i in ${line[@]}; do
                        [ "${i:0-2}" == '.c' ] && echo $i >> data_tag
                        [ "${i:0-2}" == '.S' ] && echo $i >> data_tag
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

function clean_start_with() {
        sed -i "/^$1/d" $2

}

function mk_gcc_file() {
        sed -i ':a;N;$ s/\\\n/ /g;ba' $1
        sed -i 's/;/\n/g' $1
        sed -i "s/\"//g" $1
        sed -i 's/\t/ /g' $1
        sed -i 's/  */ /g' $1
        sed -i '/^\s/s/\s//' $1
        sed -i '/^mips-linux-gnu-gcc/!d' $1
        # sed -i '/^mips-linux-gnu-gcc\|^gcc/!d' $1
}

function new_gcc_filter() {

    local file_c=
    local file_s=
    local file_h=
    local file_include=

    local line_c=
    local line_h=
    local line_include=

    while read line; do

        line_c=
        line_h=
        line_include=

        for i in ${line[@]}; do
            if [ "${i:0-2}" == '.s' ]; then
                if [ -f "$i" ]; then
                    [[ "$file_s" =~ "$i" ]] || file_s="$file_s $i"
                else
                    echo $i >> ttttt
                fi
            fi

            if [ "${i:0-2}" == '.c' ]; then
                if [ -f "$i" ]; then
                    [[ "$file_c" =~ "$i" ]] || { file_c="$file_c $i"; line_c="$line_c $i"; }
                else
                    echo $i >> ttttt
                fi
            fi

            if [ "${i:0-2}" == '.h' ]; then
                if [ -f "$i" ]; then
                    [[ "$file_h" =~ "$i" ]] || file_h="$file_h $i"
                    line_h="$line_h $i"
                else
                    echo $i >> ttttt
                fi
            fi

            if [ "${i:0:2}" == '-I' ]; then
                i="${i:2}"
                if [ -d "$i" ]; then
                    [[ "$file_include" =~ "$i" ]] || file_include="$file_include $i"
                    line_include="$line_include $i"
                else
                    echo $i >> ttttt
                fi
            fi
        done

        for i in ${line_c[@]}; do
            sed '/^#include/!d' $i > .tmp_h

            while read line; do
                if [[ "$line" =~ '.h>' ]]; then
                    head_flie=${line##* }; head_flie=${head_flie:1:0-1}
                    for j in ${line_include[@]}; do
                        if [[ -f "$j/$head_flie" ]]; then
                            [[ "$file_h" =~ "$j/$head_flie" ]] || file_h="$file_h $j/$head_flie"
                            break
                        fi
                    done

                    virtual_h=${i%/*}/$head_flie
                    if [[ -f "$" ]]; then
                        [[ "$file_h" =~ "$virtual_h" ]] || file_h="$file_h $virtual_h"
                    fi
                fi

                if [[ "$line" =~ '.h"' ]]; then
                    head_flie=${line##* }; head_flie=${head_flie:1:0-1}
                    virtual_h=${i%/*}/$head_flie
                    if [[ -f "$virtual_h" ]]; then
                        [[ "$file_h" =~ "$virtual_h" ]] || file_h="$file_h $virtual_h"
                    fi
                fi
            done < .tmp_h
        done
    done < $1

    # rm .tmp_h

    [ -n "$file_c" ] && echo $file_c > file_tag
    [ -n "$file_s" ] && echo $file_s >> file_tag
    [ -n "$file_h" ] && echo $file_h >> file_tag

    echo $file_include > file_include
    # echo $file_h >> file_include

    sed -i 's/ /\n/g' file_tag
    sed -i 's/ /\n/g' file_include
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
		if [ "${2:0-2}" == ".c" ]; then
			make_i $2
		fi
		;;
	'c')
		make clean
		;;
	't')
                [ -f '.tagfile' ] && ctags -L .tagfile || echo failed!
		;;
        'ycm_conf')
                make clean
                make uImage -n -j32 > .tmp 2>&1
                cp .tmp ttt
                # cp ttt .tmp
                mk_gcc_file .tmp
                new_gcc_filter .tmp
                # mk_h_file .tmp
                # mk_data_file .tmp data_h
                ycmadd file_include
                # rm .tmp
                ;;
	*)
		;;
	esac
} || {
	mk
}
