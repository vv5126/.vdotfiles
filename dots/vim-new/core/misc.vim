"Space to command mode.
nnoremap <space> :
vnoremap <space> :

source $evervim_root/plugins/v/vfunc.vim
source $evervim_root/plugins/v/burner.vim
source $evervim_root/plugins/v/youdao.vim

" Key (Re)Mappings

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

" Wrapped lines goes down/up to next row, rather than next line in file.
" 处理折叠行的左右移动
noremap j gj
noremap k gk

" Remove keybinding for Ex Mode
nnoremap Q <nop>

" Remap ; to : in visual mode
" nnoremap ; :

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





let g:vimrc_author='LER0ever'
let g:vimrc_email='etasry@gmail.com'
let g:vimrc_homepage='https://rongyi.blog'

" if !has('gui')
    "set term=$TERM          " Make arrow and other keys work
" endif
filetype plugin indent on   " Automatically detect file types.
syntax on
set foldmethod=indent       " Syntax highlighting | using indentation as foldmethod to speed up vim
set mouse=a                 " Automatically enable mouse usage
set mousehide               " Hide the mouse cursor while typing
set guicursor=              " Do not modify the cursor shape
scriptencoding utf-8
set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936 " support for open multi-byte encoded file
set encoding=utf-8

if has('clipboard')
    if has('unnamedplus')  " When possible use + register for copy-paste
        set clipboard=unnamed,unnamedplus
    else         " On mac and Windows, use * register for copy-paste
        set clipboard=unnamed
    endif
endif

" Most prefer to automatically switch to the current file directory when a new buffer is opened.
if exists('g:evervim_autochdir')
    autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif
endif

"set autowrite                                  "  Automatically write a file when leaving a modified buffer
set shortmess+=filmnrxoOtT                      "  Abbrev. of messages (avoids 'hit enter')
set viewoptions=folds,options,cursor,unix,slash "  Better Unix / Windows compatibility
set virtualedit=onemore                         "  Allow for cursor beyond last character
set history=1000                                "  Store a ton of history (default is 20)
set nospell                                     "  Switch off Spell checking by default
set hidden                                      "  Allow buffer switching without saving
set iskeyword-=.                                "  '.' is an end of word designator
set iskeyword-=#                                "  '#' is an end of word designator
set iskeyword-=-                                "  '-' is an end of word designator

" Instead of reverting the cursor to the last position in the buffer, we
" set it to the first line when editing a git commit message
au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

if exists('g:evervim_nosimultaneousedits')
    augroup NoSimultaneousEdits
        autocmd!
        autocmd SwapExists * let v:swapchoice = 'o'
        autocmd SwapExists * echohl ErrorMsg
        autocmd SwapExists * echo 'EverVim: Duplicate session, opening read-only ...'
        autocmd SwapExists * echohl None
        autocmd SwapExists * sleep 2
    augroup END
endif

set nofen                          " 启动时关闭折叠
set nomodeline                     " 不检查模式行
set timeoutlen=500                 " 毫秒计的等待键码或者映射的键序列完成的时间
set selection=exclusive            " 对选择区操作不包含光标所在字符
set lazyredraw                     " 执行宏时不重画
set ttyfast                        " 表明使用的是快速终端连接
set linebreak                      " 防止折行时打断单词，将整个词进行折行。
set display=lastline               " 长行显示，解决@@@@的问题
set numberwidth=4                  " 行号栏的宽度
set fillchars=vert:\ ,stl:\        " 在被分割的窗口间显示空白，便于阅读,stlnc:\(加了这个wm分割兰有\\\\\\\\\\\\\)
set cmdheight=1                    " 命令行（在状态行下）的高度，默认为1
set showtabline=1                  " 指定何时显示带有标签页标签的行,这里设置为至少有两个以上才显示.
set confirm                        " 退出、写入等有未保存的改动或文件只读时询问
set nobackup                       " 覆盖文件时不备份
set backupcopy=yes                 " 设置备份时的行为为覆盖
set nowritebackup                  " 不写入备份文件
set t_BE=
set matchtime=0			   " 匹配括号高亮的时间（单位是十分之一秒）
set selectmode=mouse,key
set wildignore+=*.bak,*.o,*.e,*~,*.obj,.git,*.pyc
set completeopt=preview,longest,menuone "代码补全
set noswapfile                     " 关闭交换文件



filetype off                       " 关闭文件类型侦测

let g:netrw_home = $VTMP

" tab的设定
set smarttab                       " 在行和段开始处使用制表符

" 支持代码折叠
set foldlevel=1               " 设置折叠层数为
set foldcolumn=0                   " 设置折叠区域的宽度
set viminfo+='1000,n$VTMP/.viminfo

" set noexpandtab           " 不要用空格代替制表符
set expandtab
" autocmd FileType sh setlocal shiftwidth=4

set bufhidden=hide
" set --- bufhidden=delete

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
autocmd WinEnter * if &buftype ==#'quickfix' && winnr('$') == 1 | quit |endif
"=====================================================
autocmd BufEnter * :syntax sync fromstart
autocmd WinLeave * lclose
"=====================================================
autocmd BufEnter * call CHECK_FILETYPE()

" autocmd BufRead *.h set filetype=c
autocmd BufRead *.help set filetype=markdown
"=====================================================

let @a="A \\j"
let @b="A \j"
let @c="vee3\j"

" Ctags {{{
set tags=./tags;/,~/.vimtags
" set tags=./.tags;,.tags

" Make tags placed in .git/tags file available in all levels of a repository
let gitroot = substitute(system('git rev-parse --show-toplevel'), '[\n\r]', '', 'g')
if gitroot != ''
    let &tags = &tags . ',' . gitroot . '/.git/tags'
endif
" }}}

if has("multi_byte")
    set fileencoding=utf-8
    " set fileencoding=gb18030
    " set fileencoding=gb2312
    let &termencoding=&encoding
    set fileencodings=utf-8,iso-8859-1,gbk,latin1,ucs-bom,cp936,gb18030,utf-16,big5,gb2312,chinese
    if v:lang=~? '^\(zh\)\|\(ja\)\|\(ko\)'
        set ambiwidth=double
    endif
endif
" set termencoding=utf-8

" nmap <F2> :set ic<cr>/
nmap <S-C> :stj <C-R>=expand("<cword>")<CR><CR>
" nmap ff :1,$s///g<LEFT><LEFT><LEFT>
" imap <C-u> <esc>d0i
" imap <C-k> <esc>d$i " 与自动补全中的绑定冲突

set modelines=1                   " set项的检查数量??
try
    call fuf#defineLaunchCommand('FufCWD', 'file', 'fnamemodify(getcwd(), ''%:p:h'')')
    map <leader>t :FufCWD **/<CR>
catch
endtry

" 排版 {{{
" set formatoptions=rqnl
" set formatoptions=rqntc            " 控制 Vim 如何对文本进行排版
" set formatoptions=tcrn2bmMB1j
" set formatoptions+=mM             "自动对中文换行
" set formatoptions+=mB
" set cindent                        " 使用C样式的缩进
" set cinoptions=:0                  " 设置 'cindent' 时如何缩进
" set smartindent                    " C 程序智能自动缩进
" set fileformats=unix,dos,mac       " 自动识别UNIX格式和MS-DOS格式     参与自动检测的 'fileformat' 的格式
" set fileformat=unix                " 以UNIX的换行符格式保存文件，注意是去掉一个^M
" -------------------------------------------------
set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace
" }}}


" 使用tab键来代替%进行匹配跳转
nnoremap <tab> %
vnoremap <tab> %

" i/a 技巧: di da vi va ya yi...
" 快速选择段中串
map <leader>u vi"

" Filetype plugins need to be enabled
filetype plugin on

" let $GTAGSLABEL = 'native-pygments'
" let $GTAGSCONF = '/backup/home/wgao/.local/share/gtags/gtags.conf'











" Make it so AutoCloseTag works for xml and xhtml files as well
au FileType xhtml,xml ru ftplugin/html/autoclosetag.vim
" nmap <Leader>ac <Plug>ToggleAutoCloseMappings

if isdirectory(expand("~/.vim/bundle/vim-powerline/"))
    " mkfontscale
    " mkfontdir
    " fc-cache -vf
    " rm ~/.vim/bundle/vim-powerline/*.cache
    " https://github.com/eugeii/consolas-powerline-vim.git
    " https://github.com/powerline/fonts.git
    " set guifont=PowerlineSymbols\ for\ Powerline
    " let g:Powerline_symbols = 'fancy'
endif

" color solarized             " Load a colorscheme

" 常用缩写
" iab xdate <c-r>=strftime("%d/%m/%y %H:%M:%S")<cr>

" 比较文件
" nnoremap <leader>df :vert diffsplit 
" nnoremap <leader>dff :diffoff<cr>

"光标所在词搜索
" nnoremap <leader>f *
" nnoremap <leader>fa :call SET_ISK()<cr>

" 窗口自动半边排版
" nnoremap <silent> <leader>; :call VZOOM()<cr>

" set rtp+=xxx/vim		   " 自定义vim目录位置
" syntax enable                      " 开启语法高亮功能

" :help digraph-table 特殊字符表

" set foldclose=all         " 设置为自动关闭折叠
" set --- foldmethod=syntax " 用语法高亮来定义折叠
" set --- foldmethod=manual " 手动折叠
" set --- foldmethod=marker " 依标志折叠
" set --- foldmethod=indent " 基于缩进或语法进行代码折叠
" set --- shiftwidth=8      " 设置格式化时制表符占用空格数
"

" 独立的剪贴板
" vmap <silent> <expr> p <sid>Repl()

" set colorcolumn=37                 " 彩色显示一列，用以规范代码
" set nocul
" set nocuc
" autocmd InsertLeave * set nocul    " 用浅色高亮当前行
" autocmd InsertEnter * set cul      " 用浅色高亮当前行
" highlight cursorLine cterm=bold ctermfg=green ctermbg=blue
" highlight cursorColumn cterm=bold ctermfg=green ctermbg=yellow
" highlight cursorColumn ctermbg=green ctermfg=green

nmap <leader>d :%s/.*expand("<cword>").*\n//g<CR> "
" {{{
" s: Find this C symbol 0或者s   —— 查找这个C符号
nmap <C-\>s :call GO_GIT_DIR()<cr>:cs find s <C-R>=expand("<cword>")<CR><CR>
" g: Find this definition 1或者g  —— 查找这个定义
nmap <C-\>g :call GO_GIT_DIR()<cr>:cs find g <C-R>=expand("<cword>")<CR><CR>
" c: Find functions calling this function 3或者c  —— 查找调用这个函数的函数（们）
nmap <C-\>c :call GO_GIT_DIR()<cr>:cs find c <C-R>=expand("<cword>")<CR><CR>
" t: Find this text string 4或者t   —— 查找这个字符串
nmap <C-\>t :call GO_GIT_DIR()<cr>:cs find t <C-R>=expand("<cword>")<CR><CR>
" e: Find this egrep pattern 6或者e  —— 查找这个egrep匹配模式
nmap <C-\>e :call GO_GIT_DIR()<cr>:cs find e <C-R>=expand("<cword>")<CR><CR>
" f: Find this file 7或者f   —— 查找这个文件
nmap <C-\>f :call GO_GIT_DIR()<cr>:cs find f <C-R>=expand("<cfile>")<CR><CR>
" i: Find files #including this file 8或者i   —— 查找#include这个文件的文件（们）
nmap <C-\>i :call GO_GIT_DIR()<cr>:cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
" d: Find functions called by this function 2或者d  —— 查找被这个函数调用的函数（们）
nmap <C-\>d :call GO_GIT_DIR()<cr>:cs find d <C-R>=expand("<cword>")<CR><CR>
set cst
set cspc=3


" unuseful.

" Visual shifting (does not exit Visual mode)
" vnoremap < <gv
" vnoremap > >gv

" Stupid shift key fixes
if !exists('g:evervim_no_keyfixes')
    if has("user_commands")
        command! -bang -nargs=* -complete=file E e<bang> <args>
        command! -bang -nargs=* -complete=file W w<bang> <args>
        command! -bang -nargs=* -complete=file Wq wq<bang> <args>
        command! -bang -nargs=* -complete=file WQ wq<bang> <args>
        command! -bang Wa wa<bang>
        command! -bang WA wa<bang>
        command! -bang Q q<bang>
        command! -bang QA qa<bang>
        command! -bang Qa qa<bang>
    endif

    cmap Tabe tabe
endif

" Code folding options
" nmap <leader>o0 :set foldlevel=0<CR>
" nmap <leader>o1 :set foldlevel=1<CR>
" nmap <leader>o2 :set foldlevel=2<CR>
" nmap <leader>o3 :set foldlevel=3<CR>
" nmap <leader>o4 :set foldlevel=4<CR>
" nmap <leader>o5 :set foldlevel=5<CR>
" nmap <leader>o6 :set foldlevel=6<CR>
" nmap <leader>o7 :set foldlevel=7<CR>
" nmap <leader>o8 :set foldlevel=8<CR>
" nmap <leader>o9 :set foldlevel=9<CR>

" Change Working Directory to that of the current file
" cmap cwd lcd %:p:h
" cmap cd. lcd %:p:h

" Adjust viewports to the same size
" map <Leader>= <C-w>=

