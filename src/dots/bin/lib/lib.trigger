export VHELPER_LOG="$DIR_VHELPER/log"

function _log() {
    echo "$(date +%d\ %H:%M)| $@" >> $VHELPER_LOG/a.log
}

function time_check()
{
    local a b c d e f
    local trigger_count=5
    time_now=$(date +%m_%d_%H_%M_%u)
    time_base=(${time_now//_/ })
    time_trigger=(${1//_/ })

    for i in {0..4}; do
	if [[ "${time_trigger[i]}" =~ ',' ]]; then
	    a="${time_trigger[i]//,/ }"
	else
	    a="${time_trigger[i]}"
	fi

	for b in $a; do
	    if [[ "${b}" =~ '/' && "${b}" =~ '-' ]]; then
		c="${b%%/*}"
		d="${b#*/}"
		if [ -z $c ]; then
		    case $i in
			0) c='00-12' break ;; 1) c='00-31' break ;; 2) c='00-24' break ;; 3) c='00-60' break ;; 4) c='1-7' break ;;
		    esac
		fi
		e="${c%%-*}"
		f="${c#*-}"
		[ "${e:0:1}" = '0' ] && e="${e:1}"
		[ "${f:0:1}" = '0' ] && f="${f:1}"
		if [[ "${time_base[i]}" -ge "$e" && "${time_base[i]}" -le "$f" && "$(((time_base[i]-$e)%$d))" -eq 0 ]]; then
		    # echo $e "${time_base[i]}" $f / $d
		    ((trigger_count--))
		    break
		fi
	    elif [[ "$b" =~ '-' ]]; then
		c="${b%%-*}"
		d="${b#*-}"
		[ "${c:0:1}" = '0' ] && c="${c:1}"
		[ "${d:0:1}" = '0' ] && d="${d:1}"
		if [[ "${time_base[i]}" -ge "$c" && "${time_base[i]}" -le "$d" ]]; then
		    # echo $c "${time_base[i]}" $d
		    ((trigger_count--))
		    break
		fi
	    else
		if [[ "x${time_base[i]}" -eq "x$b" || "x$b" -eq 'xy' ]]; then
		    # echo "${time_base[i]}" $b
		    ((trigger_count--))
		    break
		fi
	    fi
	done
    done
    [ "$trigger_count" -eq 0 ] && { echo 0; return 0; } || { echo -1; return -1; }
}

export -f time_check
export -f _log
