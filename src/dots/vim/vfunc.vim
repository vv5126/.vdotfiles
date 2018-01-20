" function {{{
" -------------------------------------------------
function! SuperPrint(Num)
    let l:tmp = @+
    let l:pre = ''
    let l:priv = ''
    if a:Num == 1
	let l:pre = l:tmp . ' = %d'
	let l:priv = ', (' . l:tmp . ')'
    else
	let l:tmp = substitute(l:tmp, '+\|=\|\*\|/\|,', ' ', 'g')
	let l:list = split(l:tmp)
	for l:i in l:list
	    if ('.-' =~ l:i) && (strlen(l:i) == 1)
		continue
	    else
		let l:pre = l:pre . ' ' . l:i . ' = %d |'
		let l:priv = l:priv . ', ' . l:i
	    endif
	endfor
    endif
    if g:code_project == 'kernel'
	call append(line('.'), 'printk("\033[31m' . l:pre . '\033[0m\n"' . l:priv . ');')
    else
	call append(line('.'), 'printf("\033[31m' . l:pre . '\033[0m\n"' . l:priv . ');')
    endif
endfunction
" -------------------------------------------------

"To hex modle
let s:hexModle = "N"
function! ToHexModle()
    if s:hexModle == "Y"
	%!xxd -r
	let s:hexModle = "N"
    else
	%!xxd
	let s:hexModle = "Y"
    endif
endfunction
" -------------------------------------------------

function! RunShell(Msg, Shell)
    echo a:Msg . '...'
    call system(a:Shell)
    echon 'done'
endfunction
" -------------------------------------------------

"set magic "改变搜索模式使用的特殊字符
function! SET_MOUSE()
    if &mouse == 'a'
	set mouse=
	echon 'mouse='
    else
	set mouse=a
	echon 'mouse=a'
    endif
endfunction
" -------------------------------------------------

" 获取当前路径，将$HOME转化为~
function! CurDir()
    let curdir = substitute(getcwd(), $HOME, "~", "g")
    return curdir
endfunction
" -------------------------------------------------

let g:isk_flag=1
function! SET_ISK()
    if g:isk_flag == 1
	set iskeyword+=.,_,$,@,%,#,-         " 含有此字符皆属于单词
	let g:isk_flag=0
	echon 'more keyword'
    else
	set iskeyword-=.,_,$,@,%,#,-         " 已此为单词分隔符
	let g:isk_flag=1
	echon 'less keyword'
    endif
endfunction
" -------------------------------------------------

" 对选中代码进行匹配
" From an idea by Michael Naumann
function! VisualSearch(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
	execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
	call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'f'
	execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction
" -------------------------------------------------

function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction
" -------------------------------------------------

function! Mktagexit()
    let g:asyncrun_exit = ''
    call GO_GIT_DIR()
    if filereadable("cscope.out")
	" exec 'cs kill cscope.out'
	exec 'cs add cscope.out'
	echo "make tag done!"
    else
	echo "make tag failed!"
    endif
endfunction
" -------------------------------------------------
function! ADD_H()
    let l:filename = substitute(toupper(expand("%:t")), '\.', "_", "g")
    call append(0,"#ifndef __".l:filename."__")
    call append(1,"#define __".l:filename."__")
    call append(2,"")
    call append('$',"#endif /* __".l:filename."__ */")
endfunction
" -------------------------------------------------

function! SET_FILETYPE_C()
    " guess project
    let g:code_project = system("tmp=$(lib.work guess_obj); echo -n ${tmp%% *}")

    " 'scrooloose/syntastic 语法检查'
    "  let g:syntastic_check_on_open=0
    " let g:syntastic_auto_loc_list = 1
    "  let g:syntastic_check_on_wq = 0
    " let syntastic_loc_list_height = 5
    let g:shiftwidth=8
    let g:tabstop=8
    " set expandtab
    " -------------------------------------------------
    " set colorcolumn=37                 " 彩色显示一列，用以规范代码
    " highlight ColorColumn ctermbg=green ctermfg=black
    " -------------------------------------------------
    " 第80列往后加下划线
    "au BufWinEnter * let w:m2=matchadd('Underlined', '\%>' . 80 . 'v.\+', -1)
    " -------------------------------------------------
    " 屏蔽代码
    vmap <Leader>j0 dO#endif<Esc>PO#if 0<cr>#else<Esc>
    vmap <Leader>jz di /*  <Esc>P
    " 调试
    vmap <Leader>jd dO#endif<Esc>PO#ifdef DEBUG<Esc>
    " -------------------------------------------------
    "切换到函数头或尾
    nmap <tab> [[
    nmap <S-tab> ]]

    " nmap  <F1> :copen<cr>:AsyncRun mk ycm_conf<cr>
    nmap  <F1> :let g:asyncrun_exit = 'call Mktagexit()'<cr>:AsyncRun mk -t<cr>:echo 'uptag ...'<cr>
    nmap  <F2> :call Burn_on()<cr>
    nmap  <F3> :call Burn_off()<cr>
    nmap  <F4> :copen<cr>:AsyncRun mk<cr>
    nmap  <F5> :cclose<cr>
    " -------------------------------------------------
    if g:code_project == 'kernel'
	iab wgao1 <c-r>='printk("\033[31m(l:%d, f:%s, F:%s) %d %s\033[0m\n", __LINE__, __func__, __FILE__, 0, "");'<cr>
	iab wgao2 <c-r>='printk("\033[31m(l:%d, f:%s, F:%s) %d %s\033[0m\n", __LINE__, __func__, __FILE__, 0, "");'<cr>
	" iab wgao1 <c-r>='printk("\033[31m(l:%d, f:%s, F:%s, p:%d) %d %s\033[0m\n", __LINE__, __func__, __FILE__, current->pid, 0, "");'<cr>
    else
	iab wgao1 <c-r>='printf("\033[31m(l:%d, f:%s, F:%s) %d %s\033[0m\n", __LINE__, __func__, __FILE__, 0, "");'<cr>
	iab wgao2 <c-r>='printf("\033[31m(l:%d, f:%s, F:%s) %d %s\033[0m\n", __LINE__, __func__, __FILE__, 0, "");'<cr>
	" iab wgao2 <c-r>='printf("\033[31m(l:%d, f:%s, F:%s, p:%d) %d %s\033[0m\n", __LINE__, __func__, __FILE__, current->pid, 0, "");'<cr>
    endif
    " -------------------------------------------------
    nnoremap <leader>ah :call ADD_H()<cr>
    " -------------------------------------------------
    map <leader>b :vs! ~/.vim/buffer<cr>
endfunction

function! UNSET_FILETYPE_C()
    vunmap <Leader>j0
    vunmap <Leader>jz
endfunction
" -------------------------------------------------

function! SET_FILETYPE_SH()
    let g:shiftwidth=4
    let g:tabstop=4
endfunction

function! UNSET_FILETYPE_SH()
endfunction
" -------------------------------------------------

function! SET_FILETYPE_VIM()
    let g:shiftwidth=4
    let g:tabstop=4
endfunction

function! UNSET_FILETYPE_VIM()
endfunction
" -------------------------------------------------

let g:filetype_last=''

function! CHECK_FILETYPE()
    if &filetype != g:filetype_last
	if g:filetype_last == 'c'
	    call UNSET_FILETYPE_C()
	elseif g:filetype_last == 'sh'
	    call UNSET_FILETYPE_SH()
	elseif g:filetype_last == 'vim'
	    call UNSET_FILETYPE_VIM()
	endif

	if &filetype == 'c'
	    call SET_FILETYPE_C()
	elseif &filetype == 'sh'
	    call SET_FILETYPE_SH()
	elseif &filetype == 'vim'
	    call SET_FILETYPE_VIM()
	endif
	" echon "the filetype is " &filetype

	let g:filetype_last=&filetype
	" echon 'filetype_last = 'g:filetype_last
    endif
endfunction
" -------------------------------------------------

function! VZOOM()
    let l:cur_nr=winnr()
    let l:nr = winnr("$")
    let l:cur_col = screencol()

    if l:cur_col < 142 || 1 == l:cur_nr
	let l:nr = 1
	while l:nr < l:cur_nr
	    exe l:nr . "wincmd w"
	    vertical resize 1
	    let l:nr += 1
	endwhile

	exe l:cur_nr . "wincmd w"
	let l:tmp_wid = 142 - (l:cur_nr - 1) * 2 - 1
	exe "vertical resize " . l:tmp_wid
    else
	let l:tmp_nr = l:cur_nr - 1
	let l:tmp_col =  142 + wincol() - l:cur_col

	exe l:tmp_nr . "wincmd w"
	exe "vertical resize +" . l:tmp_col

	exe l:cur_nr . "wincmd w"
	let l:tmp_wid = 142 - (l:nr - l:cur_nr + 1) * 2
	exe "vertical resize " . l:tmp_wid
    endif
endfunction

function! HasPaste()
    if &paste
	return '[PASTE MODE]'
    else
	return ''
    endif
endfunction

function! InsertStatuslineColor(mode)
    if a:mode == 'i'
	hi User7 ctermbg=red
    else
	hi User7 ctermbg=black
    endif
endfunction

" -------------------------------------------------

function! GO_GIT_DIR()
    let l:dir = system("getdir .git")
    let l:dir = matchstr(l:dir, '/.*')
    exec 'cd' l:dir
    exec 'pwd'
    " echon 'git dir'
endfunction
" -------------------------------------------------
"" vp doesn't replace paste buffer
function! RestoreRegister()
    let @" = s:restore_reg
    return ''
endfunction

function! s:Repl()
    let s:restore_reg = @"
    return "p@=RestoreRegister()\<cr>"
endfunction
" -------------------------------------------------
function! g:UltiSnips_Complete()
    call UltiSnips#ExpandSnippet()
    if g:ulti_expand_res == 0
	if pumvisible()
	    return "\<C-n>"
	else
	    call UltiSnips#JumpForwards()
	    if g:ulti_jump_forwards_res == 0
		return "\<TAB>"
	    endif
	endif
    endif
    return ""
endfunction

function! g:UltiSnips_Reverse()
    call UltiSnips#JumpBackwards()
    if g:ulti_jump_backwards_res == 0
	return "\<C-P>"
    endif

    return ""
endfunction
" -------------------------------------------------
" }}}
