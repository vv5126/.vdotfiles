
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
" }}} -------------------------------------------------

let g:bufmark = []

if 0

function! Vzoom()
    let cur_nr=winnr()
    if screencol() - wincol() < 140 or cur_nr == 1
	let l:nr = 1
	while l:nr < l:cur_nr
	    exe l:nr . "wincmd w"
	    vertical resize 1
	    let l:nr+=1
	endwhile
	exe l:cur_nr . "wincmd w"
	vertical resize (142 - l:nr * 2)
    else
	let l:nr = winnr("$")
	while l:nr > l:cur_nr
	    exe l:nr . "wincmd w"
	    vertical resize 1
	    let l:nr-=1
	endwhile
	exe l:cur_nr - 1 . "wincmd w"
	vertical resize (142 - (screencol() - wincol()))
    endif
endfunction

if exists("g:vimlayoutloaded")
    finish
else
    let g:vimlayoutloaded=1
endif
function! HeightToSize(height)
    let currwinno=winnr()
    if winheight(currwinno)>a:height
	while winheight(currwinno)>a:height
	    execute "normal \<c-w>-"
	endwhile
    elseif winheight(currwinno)<a:height
	while winheight(currwinno)<a:height
	    execute "normal \<c-w>+"
	endwhile
    endif
endfunction
function! WidthToSize(width)
    let currwinno=winnr()
    if winwidth(currwinno)>a:width
	while winwidth(currwinno)>a:width
	    execute "normal \<c-w><"
	endwhile
    elseif winwidth(currwinno)<a:width
	while winwidth(currwinno)<a:width
	    execute "normal \<c-w>>"
	endwhile
    endif
endfunction
function! TweakWinSize(orgisize)
    call HeightToSize(a:orgisize[0])
    call WidthToSize(a:orgisize[1])
endfunction
function! RestoreWinLayout()
    if exists("g:layout")
	let winno=1
	let orgiwinno=winnr()
	for win in g:layout
	    execute "normal \<c-w>w"
	    let currwinno=winnr()
	    if currwinno!=1 && currwinno!=orgiwinno
		call TweakWinSize(g:layout[currwinno-1])
	    endif
	endfor
	unlet g:layout
    endif
endfunction
function! SaveWinLayout()
    let wnumber=winnr("$")
    let winlist=range(wnumber)
    let winno=0
    let layout=[]
    for index in winlist
	let winno+=1
	let wininfo=[winheight(winno),winwidth(winno)]
	call add(layout,wininfo)
    endfor
    let g:layout=layout
endfunction
function! ToggleMaxWin()
    if exists("g:layout")
	if winnr("$")==len(g:layout)
	    call RestoreWinLayout()
	else
	    call SaveWinLayout()
	    execute "normal 200\<c-w>>"
	    execute "normal \<c-w>_"
	    call RestoreWinLayout()
	endif
    else
	call SaveWinLayout()
	execute "normal 200\<c-w>>"
	execute "normal \<c-w>_"
    endif
endfunction
else
" ----------------- done ----------------- "
" functions {{{1
function! IsInBuf(name)
    return index(g:bufmark, a:name)
endfunction
" MarkBuf {{{2
function! MarkBuf()
    let l:bufn = bufnr('%')
    if IsInBuf(bufname('%')) == -1
	call add(g:bufmark, bufname('%'))
	echo "add" "-->" g:bufmark
    endif
endfunction
" UnMarkBuf {{{2
function! UnMarkBuf()
    let l:bufn = bufnr('%')
    call remove(g:bufmark, bufname('%'))
    echo "remove" "-->" g:bufmark
endfunction
" CleanBuf {{{2
function! CleanBuf()
	let g:bufmark = []
    echo "clean" "-->" g:bufmark
endfunction
        map <leader>k1 :call MarkBuf()<cr>
        map <leader>k2 :call UnMarkBuf()<cr>
        map <leader>k3 :call CleanBuf()<cr>
" ----------------- done ----------------- "

" vertical resize
function! Resize_motion()
    exec MarkBuf()
    " let bufn = $1
    " let siz = 0 or 1 #big or small
    " let start = now
    " let end
    " let speed
    " bdel
	" for l in range(1, len(lines))
	"     call setline(l, lines[l-1])
	" endfor
endfunction
function! Resize_quick()
    let l:curbufs = 
    for l:i in l:curbufs
    endfor
endfunction

nnoremap sb :call Resize_motion()<cr>
nnoremap sm :call CleanBuf()<cr>

" 每个窗口有唯一的标识符，称为窗口 ID。此标识符在同一 Vim 会话中不会改变。
" win_getid() 和 win_id2tabwin() 函数可用于在窗口/标签页号和此标识符间转换。
" 同时也有窗口号，它在每次窗口打开或关闭时会改变，见 winnr()。

" winnr()
" 每个缓冲区有唯一的编号而在同一 Vim 会话中此编号不会改变。bufnr() 和bufname() 函数可用于在缓冲区名和缓冲区号间转换。
" Buf/Win Enter/Leave 等自动命令 autocommand 不会在打开窗口或读取文件时运行，只有在真正进入缓冲区后才会执行。      
" :vnew
" 窗口号可以通过 bufwinnr() 和 winnr() 来获得。
" 获取窗口信息
" :wincmd
" {count} hide

" let g:vwininfo = {}
" let g:vwininfo[0] = []
" w, h, x, y, winid, buf, 
"
" winnr([{arg}])	返回数值，当前窗口的编号
" win_getid([{win} [, {tab}]])	数值	得到 {tab} 中 {win} 的窗口 ID

function! Reset_win_info()

endfunction
endif
