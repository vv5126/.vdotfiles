#!/bin/bash
#modify.func
doit()   #处理当前目录下的非目录文件，忽略目录文件
{
	oldname=`ls | grep "$1$"`
	for name in $oldname
	do
		if [ -d "$name" ] then :
		else
			basename=`echo $name | awk -F "." '{print $1}'`  
			newname="$basename$2"
			echo -e "$PWD/$name\t\t$newname"
			mv $name $newname
			count=`expr ${count} + 1`
		fi
	done
	return 0
}

do_recursive()	#从当前目录开始，递归处理各目录
{
	doit $1 $2
	for filename in `ls`
	do
		if [ -d "$filename" ] then
			cd $filename
			do_recursive $1 $2
			cd ..
		fi
	done
	return 0
}

modify()	#处理当前目录，并报告结果，这个相当于主函数，也可以直接调用do_recursive
{
	PARAMS=2
	if [ $# -ne $PARAMS ]
	then
		echo "usage: mv_to .suf1 .suf2"
		return 1
	fi
	count=0
	do_recursive $1 $2
	echo "complete! $count files have been modified."
	return 0
}
"可以使用find来代替,但如果每个目录只能进一次就得这种递归法了.
