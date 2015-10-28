#!/bin/bash

origin_list="$PWD/ins.list"
test_dir="$HOME/hehe"

while read line; do
	src_name=${line#*=}
	dest_name=${line%%=*}
#	echo src_name = $src_name
#	echo dest_name = $dest_name
	if [ -n "$src_name" -a -n "$dest_name" ]; then
		if [ -w "$HOME/$dest_name" ]; then
			cp -rf "$HOME/$dest_name" "$HOME/.vdotfiles/.origin"
		fi
		if [ -w "$PWD/src/$src_name" ]; then
			[ -w "$HOME/$dest_name" ] && rm -r "$HOME/$dest_name"
			ln -s "$PWD/src/$src_name" "$HOME/$dest_name"
		fi
	fi
done < "$origin_list"

#	src="$PWD/src/$src_name"
#	dest="$HOME/$dest_name"
#	echo src = $src
#	echo dest = $dest
