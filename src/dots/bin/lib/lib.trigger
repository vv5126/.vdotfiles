export VHELPER_LOG="$DIR_VHELPER/log"

function _log() {
    echo "$(date +%d\ %H:%M)| $@" >> $VHELPER_LOG/a.log
}

# e.g. "time_check y_y_00_00_1-6"
function time_check()
{
    local a b c d e f tmp
    local trigger_count=5
    time_now=$(date +%m_%d_%H_%M_%u)
    time_base=(${time_now//_/ })
    time_trigger=(${1//_/ })

    for i in {0..4}; do
	tmp="${time_base[i]}"
	[ "${tmp:0:1}" = '0' ] && tmp="${tmp:1}"

	if [[ "${time_trigger[i]}" =~ ',' ]]; then
	    a="${time_trigger[i]//,/ }"
	else
	    a="${time_trigger[i]}"
	fi

	for b in $a; do
	    if [[ "x$b" == 'xy' ]]; then
		((trigger_count--))
		break
	    elif [[ "${b}" =~ '/' ]]; then
		c="${b%%/*}"
		d="${b#*/}"
		if [ -z $c ]; then
		    case $i in
			0) c='00-12' ;; 1) c='00-31' ;; 2) c='00-24' ;; 3) c='00-60' ;; 4) c='1-7' ;;
		    esac
		fi
		e="$(printf "%.f" "${c%%-*}")"
		f="$(printf "%.f" "${c#*-}")"
		if [[ "$tmp" -ge "$e" && "$tmp" -le "$f" && "$((($tmp-$e)%$d))" -eq 0 ]]; then
		    ((trigger_count--))
		    break
		fi
	    elif [[ "$b" =~ '-' ]]; then
		c="$(printf "%.f" "${b%%-*}")"
		d="$(printf "%.f" "${b#*-}")"
		if [[ "$tmp" -ge "$c" && "$tmp" -le "$d" ]]; then
		    ((trigger_count--))
		    break
		fi
	    else
		b="$(printf "%.f" $b)"
		if (("$tmp" == "$b")); then
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
