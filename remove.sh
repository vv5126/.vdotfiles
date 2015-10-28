#!/bin/bash

origin_list="$PWD/config.list"

while read line; do
	src_name=${line#*=}
	dest_name=${line%%=*}
	if [ -w "$HOME/$dest_name" ]; then
		rm -rf "$HOME/$dest_name"
	fi
	if [ -w "$HOME/.vdotfiles/.origin/$dest_name" ]; then
		cp -r "$HOME/.vdotfiles/.origin/$dest_name" "$HOME"
	fi
done < "$origin_list"

#	echo $line
#	if [ -w "$HOME/$line" ]; then
#		cp -r "$PWD/.origin/$line"
#	echo src_name = $src_name
#	echo dest_name = $dest_name
#	if [ -n "$src_name" -a -n "$dest_name" ]; then
#		src="$PWD/src/$src_name"
#		dest="$HOME/$dest_name"
#	echo src = $src
#	echo dest = $dest
#		if [ -w "$PWD/src/$src_name" ]; then
#			ln -s "$PWD/src/$src_name" $test_dir/$dest_name
#		fi
#	fi

