#!/bin/bash

if [ $# -gt 0 ];then
	if [ $1 == "all" ]; then
		gbs -v build -A mipsel --include-all --overwrite 2>&1|tee build.log
	else
		gbs -v build -A mipsel --include-all --overwrite $1 2>&1|tee build.log
	fi
fi
