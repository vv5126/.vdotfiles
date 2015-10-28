#!/bin/bash

local_clip=/tmp/localClipboard

function vpush() {
	[ "$#" -gt 1 ] && {
		[ ${!#} == '-g' ] && {
			shift
			FILES=$@
			FILES=${FILES% *}
			echo $FILES
			sever=${VGL_CLIPBOARD%:*}
			clip_dir=${VGL_CLIPBOARD##*:}
			ssh "$sever" "rm -rf $clip_dir"
			ssh "$sever" "mkdir $clip_dir"
			scp -rq $FILES $VGL_CLIPBOARD
		} || {
			[ -d "$local_clip" ] && rm -rf "$local_clip"
			mkdir $local_clip
			shift
			cp -rf $@ $local_clip/
		}
		exit
	}
}

function vpull() {
	[ "$#" -ge 1 ] && {
		[ ${!#} == '-g' ] && {
			scp -rq $VGL_CLIPBOARD/* .
		} || {
			[ -d "$local_clip" ] && cp -r $local_clip/* .
		}
		exit
	}
}

