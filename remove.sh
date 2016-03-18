#!/bin/bash

origin_list="$PWD/config.list"
origin_dir="$HOME/.local/.origin"

while read line; do
	src_name=${line#*=}
	dest_name=${line%%=*}
	if [ -w "$HOME/$dest_name" ]; then
		rm -rf "$HOME/$dest_name"
	fi
	if [ -w "$origin_dir/$dest_name" ]; then
		cp -r "$origin_dir/$dest_name" "$HOME"
	fi
done < "$origin_list"

rm $HOME/.bash_history 2>/dev/null
rm $HOME/.cdlist 2>/dev/null
rm $HOME/.viminfo 2>/dev/null
rm $HOME/.vim_mru_files 2>/dev/null
#rm -rf $HOME/.origin 2>/dev/null
rm -rf $HOME/.clipboard 2>/dev/null
#rm -rf $HOME/.rm 2>/dev/null
#rm -rf $HOME/.vdotfiles 2>/dev/null

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

