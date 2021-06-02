" useful function {{{

" SuperPrint {{{
function! SuperPrint(Num)
    let l:tmp = @+
    let l:pre = ''
    let l:priv = ''
    if a:Num == 1
        let l:pre = l:tmp . ' = %d'
        let l:priv = ', (' . l:tmp . ')'
    else
        let l:tmp = substitute(l:tmp, ';\|+\|=\|\*\|/\|,\|&\|!', ' ', 'g')
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
        call append(line('.'), 'printk("\033[33m' . l:pre . '\033[0m\n"' . l:priv . ');')
    else
        call append(line('.'), 'printf("\033[33m' . l:pre . '\033[0m\n"' . l:priv . ');')
    endif
endfunction
" }}} -------------------------------------------------

" 对选中文本进行匹配 {{{
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
" }}} -------------------------------------------------

"为头文件添加防重复头 {{{
function! ADD_H()
    let l:filename = substitute(toupper(expand("%:t")), '\.', "_", "g")
    call append(0,"#ifndef __".l:filename."__")
    call append(1,"#define __".l:filename."__")
    call append(2,"")
    call append(3,"#ifdef __cplusplus")
    call append(4,"extern \"C\" {")
    call append(5,"#endif")
    call append(6,"")
    call append('$-5',"")
    call append('$-4',"#ifdef __cplusplus")
    call append('$-3',"}")
    call append('$-2',"#endif")
    call append('$-1',"")
    call append('$',"#endif /* __".l:filename."__ */")
endfunction
" }}} -------------------------------------------------

" GO GIT DIR {{{
function! GO_GIT_DIR()
    let l:dir = system("lib.base getdir .git")
    let l:dir = matchstr(l:dir, '/.*')
    exec 'cd' l:dir
    exec 'pwd'
    " echon 'git dir'
endfunction
" }}} -------------------------------------------------

" for statusline {{{
function! InsertStatuslineColor(mode)
    if a:mode == 'i'
	hi User7 ctermbg=red
    else
	hi User7 ctermbg=black
    endif
endfunction

" 获取当前路径，将$HOME转化为~
function! CurDir()
    let curdir = substitute(getcwd(), $HOME, "~", "g")
    return curdir
endfunction

function! HasPaste()
    if &paste
	return '[PASTE MODE]'
    else
	return ''
    endif
endfunction
" }}} -------------------------------------------------

" 为工程生成tag文件和cscope.out. {{{
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
" }}} -------------------------------------------------

" 配置*搜索单词分隔方式 {{{
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
" }}} -------------------------------------------------

" UltiSnips 触发与Youcomplete复用 {{{
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
    else
        return ""
    endif
endfunction
" }}} -------------------------------------------------

" useful function end }}}

" To hex modle {{{
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
" }}} -------------------------------------------------

" set magic "改变搜索模式使用的特殊字符 {{{
function! SET_MOUSE()
    if &mouse == 'a'
	set mouse=
	echon 'mouse='
    else
	set mouse=a
	echon 'mouse=a'
    endif
endfunction
" }}} -------------------------------------------------

function! RunShell(Msg, Shell)
    echo a:Msg . '...'
    call system(a:Shell)
    echon 'done'
endfunction

function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction
" }}} -------------------------------------------------

" RestoreRegister {{{
" vp doesn't replace paste buffer
function! RestoreRegister()
    let @" = s:restore_reg
    return ''
endfunction
" }}} -------------------------------------------------

" Run_mk {{{
function! Run_mk()
    let l:old=winnr()
    execute "vertical copen"
    execute "AsyncRun mk"
    let l:new = winnr() - l:old
    execute l:new . "wincmd h"
endfunction
" }}} -------------------------------------------------

function! s:Repl()
    let s:restore_reg = @"
    return "p@=RestoreRegister()\<cr>"
endfunction
" }}} -------------------------------------------------
