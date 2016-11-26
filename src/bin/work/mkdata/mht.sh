#!/bin/bash

# for manhattan project

. ~/.bin/ini/ini.work

function mk() {
    local new_target_name=
	source .project_info
        [ "$needclean" = "1" ] && make clean
        [ -f "$the_image" ] && rm -r $the_image
        make && {
            new_target_name=$target_name
            echo -e "\n  the out img: $target_dir/$new_target_name" >&2
            smkdir $target_dir
            scp "out/$target_name" $target_dir/$new_target_name
        }
}


function init(){
	local tmp=
        local real_br=

        source build/envsetup.sh
        lunch
        [ $? -ne 0 ] && exit
        # [ -z $TARGET_PRODUCT ] && { echo 'need lunch the project frist!' >&2; exit; }

        platfrom_name=manhattan
        forOS=manhattan

        project_type=$TARGET_PRODUCT
        forBOARD=$TARGET_DEVICE

        cd .repo/manifests
	git_remote=$(git remote -v | head -2 | tail -1 | awk '{print $2}')
	git_branch=$(git branch | grep '*' | awk '{print $2}')
        real_br=$(git branch -a | grep '\->' -)
        cd -

	target_dir='$VGL_BOARDS/$forBOARD-$forOS-imgs'
	target_name='$project_type-$forBOARD-$forOS'

        the_image=out/product/$forBOARD

	repositories_type='repo'

	make_info_file

        echo '' >> .project_info
        echo '#'$real_br >> .project_info

	return 0
}

[ "$#" -ge 1 ] && {
	case "$1" in
	'init')
		init
		;;
	'c')
		make clean
		;;
	*)
		;;
	esac
} || {
	mk
}
