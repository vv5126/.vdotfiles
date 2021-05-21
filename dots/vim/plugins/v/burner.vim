highlight User8 ctermbg=blue

function! Repeat_space(str, len, left_or_right)
    if a:left_or_right == 'l'
	return a:str . repeat(' ', a:len - strlen(a:str))
    elseif a:left_or_right == 'm'
	let l:half = (a:len - strlen(a:str)) / 2
	if (a:len - strlen(a:str)) % 2 == 0
	    return repeat(' ', l:half) . a:str . repeat(' ', l:half)
	else
	    return repeat(' ', l:half) . a:str . repeat(' ', l:half + 1)
	endif
    else
	return repeat(' ', a:len - strlen(a:str)) . a:str
    endif
endfunc

function! Cb_burn(channel, msg)
    let l:tmp = a:msg
    if l:tmp =~# '^info*'
	let g:burn_info = Repeat_space(substitute(l:tmp, 'info ', '', ''), 8, 'm')
    elseif l:tmp =~# '^process*'
	let g:burn_process = substitute(l:tmp, 'process ', '', '')
	if g:burn_process == 100
	    hi User8 ctermbg=green
	    let g:space = repeat(' ', 100)
	    let g:blank = ''
	elseif g:burn_process == 0
	    let g:space = ''
	    let g:blank = repeat(' ', 100)
	else
	    hi User8 ctermbg=yellow
	    let g:space = repeat(' ', g:burn_process)
	    let g:blank = repeat(' ', 101 - g:burn_process)
	endif
	let g:burn_process = Repeat_space(g:burn_process, 3, 'r')
    endif
    set statusline=%6*[%{g:burn_info}]%*\ [%8*%{g:space}%6*%{g:blank}%*]\ %{g:burn_process}\%%%=\ \ \ \ \ \ \ \ \ \ %4*[%{&ff}][%{&encoding}]%6*%y%*[Line:%2*%l%*/%2*%L%*,Column:%2*%c%*][%2*%p%%%*]
endfunc

function! Burn_on() "{{{
    let g:burn_info = ''
    let g:space = ''
    let g:blank = repeat(' ', 100)
    let g:burn_process = 0
    let g:job = job_start(["bn", "vim"], {"out_cb": "Cb_burn"})
endfunction "}}}

function! Burn_off() "{{{
    call job_stop(g:job)
    unlet g:burn_info
    unlet g:burn_process
    unlet g:space
    unlet g:blank
    set statusline=%7*\ %3*%{HasPaste()}%*[file:\ %2*%t%r%h%w%*]%3*%m%*[dir:\ %<%2*%{CurDir()}%*]%=\ \ \ \ \ \ \ \ \ \ %4*[%{&ff}][%{&encoding}]%6*%y%*[Line:%2*%l%*/%2*%L%*,Column:%2*%c%*][%2*%p%%%*]
endfunction "}}}
