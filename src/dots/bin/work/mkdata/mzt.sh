#!/bin/bash

# for manhattan project

. ~/.bin/ini/ini.work
. ~/.bin/lib/lib.work
. ~/.bin/lib/lib.shdb

function make_info_file() {
        local file=$1
        local str="
	# [base]

        task_type=$task_type

	customer=$customer

	feature=$feature

	forBOARD=$forBOARD

	project_type=$project_type

        the_img_dir=$the_img_dir

	# [opt]

	needclean=$needclean

	addtime=$addtime

	note=$note

	# [out]

	target_dir=$target_dir

	# [unuse]

	repositories_type=repo

	git_remote=$git_remote

	git_branch=$git_branch
        "

        shdb -f "$file" -a "$str"
}

function mkmain() {
    source .project_info

    if [ "$TRIGGER_DIR" != "$PWD" ]; then
	path=$TRIGGER_DIR
	while [ -n $path ]; do
	    [ -f "$path/Makefile" ] && break || path="${path%/*}"
	done

	if [ -n $path ]; then
	    job="${path##*/}"
	    echo $job
	    make $job-rebuild
	fi
    fi
    make -j20

    _nv=$(md5sum "output/target/nv.img" | awk '{print $1}')
    _usrdata=$(md5sum "output/target/usrdata.jffs2" | awk '{print $1}')
    _updater=$(md5sum "output/target/updater.cramfs" | awk '{print $1}')
    _appfs=$(md5sum "output/target/appfs.cramfs" | awk '{print $1}')

    source .md5

    [ "$nv" != "$_nv" ] && echo "nv changed."
    # [ "$usrdata" != "$_usrdata" ] && echo "usrdata changed."
    [ "$updater" != "$_updater" ] && echo "updater changed."
    [ "$appfs" != "$_appfs" ] && echo "appfs changed."

    echo nv=$_nv > .md5
    echo usrdata=$_usrdata >> .md5
    echo updater=$_updater >> .md5
    echo appfs=$_appfs >> .md5

    # [ "$needclean" = "1" ] && make clean

    # make -j30 && {
    #     echo -e "\n  the out img dir: $target_dir" >&2
    #     smkdir "$target_dir"
    #     scp -r "$the_img_dir" "$target_dir"
    # }
}


function init() {
        trap "rm -f .mzt.sh .project_info; exit 2" 1 2 3 15

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
                    mv "$PWD" "$project_target_dir/kernel_$feature" && ln -s "$project_target_dir/kernel_$feature" ~
                    echo the project has move to "$project_target_dir/kernel_$feature"
                fi
            }
        fi

	git_remote="$(git remote -v | head -2 | tail -1 | awk '{print $2}')"
	git_branch="$(git branch | grep '*' | awk '{print $2}')"
        if [[ "$git_branch" =~ '(' ]]; then
            tmp=$(git branch -a | grep -o '\->.*$')
            git_branch=${tmp##*/}
        fi

        project_type=mozart
        forBOARD=canna

        the_img_dir=output/target
        [ -z "$target_dir" ] && target_dir='$VGL_BOARDS/$task_type/${customer:+$customer/}$feature'

	target_name='$project_type-$forBOARD-$forOS'

	make_info_file ".project_info"
	return 0
}

[ "$#" -ge 1 ] && {
	case "$1" in
	'init')
		init
		;;
	'cfg')
		
		;;
	'c')
		make distclean
		;;
	*)
		;;
	esac
} || {
	mkmain
}

shdb_format ".project_info" &
