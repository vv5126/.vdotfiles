" 刷新插件
nmap <F6> :PlugStatus<cr>
" 更新插件
nmap <S-F6> :PlugInstall<cr>

" my setting {{{
filetype off                       " 关闭文件类型侦测
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

" --- set undofile                     " 无限undo
set bufhidden=hide
" set --- bufhidden=delete
" set --- shell=/bin/bash
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

" 空格键替换为换行
" nnoremap <S-k> :s/ \+/\r/g<cr>:noh<cr>
vnoremap <S-k> :s/ \+/\r/g<cr>:noh<cr>

"使用<leader>空格来取消搜索高亮
nnoremap <silent> <leader><space> :noh<cr>

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
vnoremap <silent> p p`]
nnoremap <silent> p p`]

" Switching between buffers.
" nnoremap <C-x> <c-w>\|<c-w>_

" 为选中代码加括号啥的
vnoremap 1 h<esc>`>a)<esc>`<i(<esc>
" vnoremap 2 h<esc>`>a]<esc>`<i[<esc> 'bug for vv'
vnoremap 3 h<esc>`>a}<esc>`<i{<esc>
vnoremap 4 h<esc>`>a"<esc>`<i"<esc>
vnoremap 5 h<esc>`>a'<esc>`<i'<esc>

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
" map <leader>e :e! ~/.vimrc<cr>
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
"自动载入配置文件不需要重启
autocmd! bufwritepost vimrc source %
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

