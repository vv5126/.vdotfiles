" 刷新插件
nmap <F6> :PlugStatus<cr>
" 更新插件
nmap <S-F6> :PlugInstall<cr>

" my setting {{{
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
set noswapfile                     " 关闭交换文件
" }}}

" statusline {{{
highlight StatusLine cterm=bold ctermfg=gray ctermbg=black
highlight LineNr ctermfg=gray ctermbg=black                       " 侧边颜色
highlight User1 ctermfg=gray
highlight User2 ctermfg=green
highlight User3 ctermfg=red
highlight User4 ctermfg=yellow
highlight User5 ctermfg=black
highlight User6 ctermfg=blue
highlight User7 ctermbg=black
set statusline=%7*\ %3*%{HasPaste()}%*[file:\ %2*%t%r%h%w%*]%3*%m%*[dir:\ %<%2*%{CurDir()}%*]%=\ \ \ \ \ \ \ \ \ \ %4*[%{&ff}][%{&encoding}]%6*%y%*[Line:%2*%l%*/%2*%L%*,Column:%2*%c%*][%2*%p%%%*]

au InsertEnter * call InsertStatuslineColor('i')
au InsertLeave * call InsertStatuslineColor('')
" statusline end }}}

" my map {{{
"Space to command mode.
nnoremap <space> :
vnoremap <space> :

" Markdown
map <leader>md :MarkdownPreview<cr>

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

" 没sudo却想保存
cmap w!! w !sudo tee % >/dev/null

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
" 查找冲突的地方
" ========>>> ...
map <leader>fc /\v^[<\|=>]{7}( .*\|$)<CR>
"=====================================================
" my map end }}}

" autocmd {{{
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
" autocmd end }}}

let @a="A \\j"
let @b="A \j"
let @c="vee3\j"

" Ctags {{{
set tags=./tags;/,~/.vimtags

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

nmap <F2> :set ic<cr>/
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

source $evervim_root/plugins/v/p/vfunc.vim
source $evervim_root/plugins/v/p/burner.vim
source $evervim_root/plugins/v/p/youdao.vim


" 使用tab键来代替%进行匹配跳转
nnoremap <tab> %
vnoremap <tab> %

" i/a 技巧: di da vi va ya yi...
" 快速选择段中串
map <leader>u vi"

" Filetype plugins need to be enabled
filetype plugin on

