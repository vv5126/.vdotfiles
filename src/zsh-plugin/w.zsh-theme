#!/usr/bin/env zsh

for COLOR in CYAN WHITE YELLOW MAGENTA BLACK BLUE RED DEFAULT GREEN GREY; do
    eval PR_$COLOR='%{$fg[${(L)COLOR}]%}'
    eval PR_BRIGHT_$COLOR='%{$fg_bold[${(L)COLOR}]%}'
done

PR_RESET="%{$reset_color%}"
RED_START="${PR_RESET}${PR_GREY}<${PR_RESET}${PR_RED}<${PR_BRIGHT_RED}<${PR_RESET} "
RED_END="${PR_RESET}${PR_BRIGHT_RED}>${PR_RESET}${PR_RED}>${PR_GREY}>${PR_RESET} "
GREEN_END="${PR_RESET}${PR_BRIGHT_GREEN}>${PR_RESET}${PR_GREEN}>${PR_GREY}>${PR_RESET}"
GREEN_BASE_START="${PR_RESET}${PR_GREY}>${PR_RESET}${PR_GREEN}>${PR_BRIGHT_GREEN}>${PR_RESET}"
GREEN_START_P1="${PR_RESET}${GREEN_BASE_START}${PR_RESET} "

local HOST_COLOR

if [[ "$USER" == 'user' && "$HOST" == 'ThinkPad-Yoga-260' ]]; then
    HOST_COLOR="%{$fg[magenta]%}"
elif [[ "$USER" == '' && "$HOST" == '' ]]; then
    HOST_COLOR="%{$fg[blue]%}"
fi

local pwd='%{$fg[blue]%}%~%{$reset_color%}'
local return_code='%(?..%{$fg[red]%}%? ↵%{$reset_color%})'

PROMPT="${return_code} ${HOST_COLOR}⌚ %T${PR_RESET} ${pwd} ${GREEN_BASE_START} "

# local weather=''
# local today=
# RPROMPT="${weather}"
# ⇒ %D{%d}
