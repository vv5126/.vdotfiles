" General
let g:vimrc_author='LER0ever'
let g:vimrc_email='etasry@gmail.com'
let g:vimrc_homepage='https://rongyi.blog'

set background=dark         " Assume a dark background

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

" http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
" Restore cursor to file position in previous editing session
" This may cause NERDTree and tagbar's abnormal behavior
" To disable this, add the following to your .vimrc.before.local file:
"   let g:evervim_no_restore_cursor = 1
" deprecated, replaced by vim-lastplace

"if !exists('g:evervim_no_restore_cursor')
    "function! ResCur()
        "if line("'\"") <= line("$")
            "silent! normal! g`"
            "return 1
        "endif
    "endfunction

    "augroup resCur
        "autocmd!
        "autocmd BufWinEnter * call ResCur()
    "augroup END
"endif

" Setting up the directories {
    set backup                  " Backups are nice ...
    if has('persistent_undo')
        set undofile                " 无限undo ...
        set undolevels=1000         " Maximum number of changes that can be undone
        set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
    endif
" }

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
