"Space to command mode.
nnoremap <space> :
vnoremap <space> :

" 刷新插件
nmap <F6> :PlugStatus<cr>
" 更新插件
nmap <S-F6> :PlugInstall<cr>

" 空格键替换为换行
" nnoremap <S-k> :s/ \+/\r/g<cr>:noh<cr>
vnoremap <S-k> :s/ \+/\r/g<cr>:noh<cr>

"使用<leader>空格来取消搜索高亮
nnoremap <silent> <leader><space> :noh<cr>:pclose<cr>

"去空行
nnoremap <leader>db :g/^\s*$/d<cr>

"清除末尾空格
nnoremap <leader>ds :%s/\s\+$//<cr>
nmap fk :1,$s/ *$//g<cr>

"函数内排版
nmap = =a{

"清除选中行中所有空格
nnoremap <leader>dd :s/[ \t]\{1,}//g<cr>:noh<cr>
vnoremap <leader>dd :s/[ \t]\{1,}//g<cr>:noh<cr>

"清除选中行中空格,保留一个
nnoremap <leader>d1 :s/[ \t]\{1,}/ /g<cr>:noh<cr>
vnoremap <leader>d1 :s/[ \t]\{1,}/ /g<cr>:noh<cr>

" 切换目录
noremap <leader>1 :execute "cd" expand("%:h")<CR>:execute 'pwd'<cr>
noremap <leader>2 :call GO_GIT_DIR()<cr>

"删除行尾的一个^M
nmap dm :%s/\r\+$//e<cr>:set ff=unix<cr>
" noremap <Leader>m2 mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm
" noremap <Leader>ff :%s/\\\$//g<cr>:%s/\\\/ /g<cr>

"esc的映射
imap jj <esc>

" 好用的复制、粘贴
vmap <C-c> "+y
imap <C-v> <Esc>"*pa
vnoremap <silent> y y`]
" vnoremap <silent> p p`]
" nnoremap <silent> p p`]
vnoremap <silent> p "+p`] :let @"=@0<cr>:let @*=@0<cr>:let @+=@0<cr>:let @-=@0<cr>
nnoremap <silent> p "+p`]

" Switching between buffers.
" nnoremap <C-x> <c-w>\|<c-w>_

" 为选中代码加括号啥的
vnoremap 1 h<esc>`>a)<esc>`<i(<esc>
" vnoremap 2 h<esc>`>a]<esc>`<i[<esc> 'bug for vv'
vnoremap 3 h<esc>`>a}<esc>`<i{<esc>
vnoremap 4 h<esc>`>a"<esc>`<i"<esc>
vnoremap 5 h<esc>`>a'<esc>`<i'<esc>

" Wrapped lines goes down/up to next row, rather than next line in file.
" 处理折叠行的左右移动
noremap j gj
noremap k gk

" Easier moving in tabs and windows
if !exists('g:evervim_no_easyWindows')
    map <C-J> <C-W>j
    map <C-K> <C-W>k
    map <C-L> <C-W>l
    map <C-H> <C-W>h
    " map <C-J> <C-W>j<C-W>_
    " map <C-K> <C-W>k<C-W>_
    " map <C-L> <C-W>l<C-W>_
    " map <C-H> <C-W>h<C-W>_
    nnoremap <Leader>jh 1<C-W>w
    nnoremap <Leader>jl 1<C-W>b
endif


" End/Start of line motion keys act relative to row/wrap width in the
" presence of `:set wrap`, and relative to line for `:set nowrap`.
" Default vim behaviour is to act relative to text line in both cases
" If you prefer the default behaviour, add the following to your
" .vimrc.before.local file:
"   let g:evervim_no_wrapRelMotion = 1
if !exists('g:evervim_no_wrapRelMotion')
    " Same for 0, home, end, etc
    function! WrapRelativeMotion(key, ...)
        let vis_sel=""
        if a:0
            let vis_sel="gv"
        endif
        if &wrap
            execute "normal!" vis_sel . "g" . a:key
        else
            execute "normal!" vis_sel . a:key
        endif
    endfunction

    " Map g* keys in Normal, Operator-pending, and Visual+select
    noremap $ :call WrapRelativeMotion("$")<CR>
    noremap <End> :call WrapRelativeMotion("$")<CR>
    noremap 0 :call WrapRelativeMotion("0")<CR>
    noremap <Home> :call WrapRelativeMotion("0")<CR>
    noremap ^ :call WrapRelativeMotion("^")<CR>
    " Overwrite the operator pending $/<End> mappings from above
    " to force inclusive motion with :execute normal!
    onoremap $ v:call WrapRelativeMotion("$")<CR>
    onoremap <End> v:call WrapRelativeMotion("$")<CR>
    " Overwrite the Visual+select mode mappings from above
    " to ensure the correct vis_sel flag is passed to function
    vnoremap $ :<C-U>call WrapRelativeMotion("$", 1)<CR>
    vnoremap <End> :<C-U>call WrapRelativeMotion("$", 1)<CR>
    vnoremap 0 :<C-U>call WrapRelativeMotion("0", 1)<CR>
    vnoremap <Home> :<C-U>call WrapRelativeMotion("0", 1)<CR>
    vnoremap ^ :<C-U>call WrapRelativeMotion("^", 1)<CR>
endif

" The following two lines conflict with moving to top and
" bottom of the screen
" If you prefer that functionality, add the following to your
" .vimrc.before.local file:
"   let g:evervim_no_fastTabs = 1
if !exists('g:evervim_no_fastTabs')
    map <S-H> gT
    map <S-L> gt
endif

" Yank from the cursor to the end of the line, to be consistent with C and D.
nnoremap Y y$

" Most prefer to toggle search highlighting rather than clear the current
" search results. To clear search highlighting rather than toggle it on
" and off, add the following to your .vimrc.before.local file:
"   let g:evervim_clear_search_highlight = 1
if exists('g:evervim_clear_search_highlight')
    nmap <silent> <leader>/ :nohlsearch<CR>
else
    nmap <silent> <leader>/ :set invhlsearch<CR>
endif

" Helper for saving file
noremap <C-S> :update<CR>
vnoremap <C-S> <C-C>:update<CR>
inoremap <C-S> <C-O>:update<CR>

" Helper for sync scrolling and Diffing
" Mark current buffer for syncing view
noremap <Leader>wv :set scb<CR>
" Mark current buffer for diffing
noremap <Leader>wd :diffthis<CR>

" Find merge conflict markers
noremap <SID>FindMergeConflictMarker /\v^[<\|=>]{7}( .*\|$)<CR>
map <leader>fx <SID>FindMergeConflictMarker
" 查找冲突的地方
" ========>>> ...
map <leader>fc /\v^[<\|=>]{7}( .*\|$)<CR>
"=====================================================

" Shortcuts
" Allow using the repeat operator with a visual selection (!)
" http://stackoverflow.com/a/8064607/127816
vnoremap . :normal .<CR>

" For when you forget to sudo.. Really Write the file.
cmap w!! w !sudo tee % >/dev/null

" Dos Unix FF Conversion
" nnoremap <Leader>fcu :call Dos2Unix()<CR>
" nnoremap <Leader>fcd :call Unix2Dos()<CR>

" Some helpers to edit mode
cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>
map <leader>et :tabe %%

" Map <Leader>ff to display all lines with keyword under cursor
" and ask which one to jump to
nnoremap <SID>FindTextUnderCursor [I:let nr = input("Which one to jump to: ")<Bar>exe "normal " . nr ."[\t"<CR>
nmap <Leader>ff <SID>FindTextUnderCursor

" Easier horizontal scrolling
map zl zL
map zh zH

" Easier formatting
nnoremap <silent> <leader>fq gwip
nnoremap <silent> <leader>fQ ggVGgq
nnoremap <silent> <leader>fk vipJ
nnoremap <silent> <leader>fK :%norm vipJ<cr>

" fullscreen mode for GVIM and Terminal, need 'wmctrl' in you PATH
" map <silent> <F11> :call system("wmctrl -ir " . v:windowid . " -b toggle,fullscreen")<CR>

" Open a new instance tab
nnoremap <Leader>tn :tabnew +Startify<CR>

if has('nvim')
    tnoremap <Esc> <C-\><C-n>
    nnoremap <Leader>te :tabe term://$SHELL<CR>i
    nnoremap <Leader>tv :vsp term://$SHELL<CR>i
    nnoremap <Leader>ts :sp term://$SHELL<CR>i
    nnoremap <C-\><C-q> :call GuiClose()<CR>
endif


" wgao

" 对选中代码进行匹配
vnoremap <silent> * :call VisualSearch('f')<CR>
vnoremap <silent> # :call VisualSearch('b')<CR>
" When you press gv you vimgrep after the selected text
" vnoremap <silent> gv :call VisualSearch('gv')<CR>

"插入模式下移动
inoremap <c-h> <C-o><S-Left>
inoremap <c-j> <C-o><left>
inoremap <c-k> <C-o><right>
inoremap <c-l> <C-o><c-right>
inoremap <C-a> <C-o><HOME>
inoremap <C-e> <C-o><END>
inoremap <C-b> <S-Left>
" inoremap <C-h> <left>
" inoremap <C-j> <down>
" inoremap <C-k> <up>
" inoremap <C-l> <right>

" buffer缩放
" nmap <S-j> 20<C-w>-
" nmap <S-k> 20<C-w>+
nmap <S-l> 20<C-w>>
nmap <S-h> 20<C-w><

"设置tab宽度
map <leader>t2 :setlocal shiftwidth=2<cr>
map <leader>t4 :setlocal shiftwidth=4<cr>
map <leader>t8 :setlocal shiftwidth=8<cr>

"Esc 键不让光标左移
" inoremap <silent> <Esc> <C-o>:stopinsert<CR>

" Bash like keys for the command line
cnoremap <C-A> <Home>
cnoremap <C-E> <End>
cnoremap <C-K> <C-U>
cnoremap <C-P> <Up>
cnoremap <C-N> <Down>

" Markdown
" map <leader>md :MarkdownPreview<cr>

"Tabel
nnoremap <S-q> :tabprevious<CR>
nnoremap <S-w> :tabnext<CR>
nnoremap te :tabedit 
nnoremap tm :tabmove 
" nnoremap 1 1gt
" nnoremap 2 2gt
" nnoremap 3 3gt

nmap <A-j> mz:m+<cr>`z
" dot 文件生成并预览
" :autocmd BufRead,BufNewFile *.dot map <F5> :w<CR>:!dot -Tjpg -o %<.jpg % && eog %<.jpg  <CR><CR> && exec "redr!"

"设置鼠标粘贴模式
nnoremap <leader>mo :call SET_MOUSE()<cr>

"使用,v来选择刚刚复制的段落，这样可以用来缩进
" nnoremap <leader>v v`]

" 清除前面数字加. exaple 12.aaa-->aaa 不适合代码！！！
" nnoremap ff :1,$s///g

"=====================================================
nnoremap <C-]> g]
map <C-]> g]
" gd 代替 *
" g] 代替 C-]
"=====================================================

" Remove keybinding for Ex Mode
nnoremap Q <nop>

" Remap ; to : in visual mode
" nnoremap ; :

" nmap  <F2> :call Burn_on()<cr>
" nmap  <F3> :call Burn_off()<cr>

" nmap <F2> :set ic<cr>/
nmap <S-C> :stj <C-R>=expand("<cword>")<CR><CR>
" nmap ff :1,$s///g<LEFT><LEFT><LEFT>
" imap <C-u> <esc>d0i
" imap <C-k> <esc>d$i " 与自动补全中的绑定冲突

" 使用tab键来代替%进行匹配跳转
nnoremap <tab> %
vnoremap <tab> %

" i/a 技巧: di da vi va ya yi...
" 快速选择段中串
map <leader>u vi"

" 比较文件
" nnoremap <leader>df :vert diffsplit 
" nnoremap <leader>dff :diffoff<cr>

