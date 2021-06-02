" Vim UI
if !exists('g:evervim_color_theme')
    if filereadable(expand(EverVimBundleDir("vim/colors/dracula.vim")))
        let g:evervim_color_theme = "dracula"
    else
        silent !echo "No color theme available, falling back to desert ..."
        let g:evervim_color_theme = "desert"
    endif
endif

if !exists('g:evervim_airline_theme')
    " Default to dracula, "Dracula" for lightline.
    let g:evervim_airline_theme = "dracula"
endif

if !exists('g:evervim_light_background')
    set background=dark     " Assume a dark background
else
    set background=light
endif

" Colorscheme changed here
execute 'color ' . g:evervim_color_theme

" Default Font setting
if !exists('g:evervim_font')
    let g:evervim_font = WINDOWS() ? (NVIM() ? "Knack NF" : "Knack_NF") : "Knack Nerd Font Mono"
endif
if !exists('g:evervim_font_size')
    let g:evervim_font_size = WINDOWS() ? "11" : "12"
endif

set tabpagemax=15                                      " Only show 15 tabs
set showmode                                           " Display the current mode

set cursorline                                         " Highlight current line 高亮光标所在行
" set cursorcolumn                                      " Highlight current column

highlight clear SignColumn                             " SignColumn should match background
highlight clear LineNr                                 " Current line number row will have same background color in relative mode
" highlight clear CursorLineNr                          " Remove highlight color from current line number

if has('cmdline_info')
    set ruler                                          " Show the ruler 显示标尺
    set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
    set showcmd                                        " Show partial commands in status line and Selected characters/lines in visual mode 输入的命令显示出来，看的清楚些
endif

if has('statusline')
    set laststatus=2   " 启动显示状态行(1),总是显示状态行(2)

    " Broken down into easily includeable segments
    set statusline=%t%m%r                         " Filename
    " set statusline+=%w%h%m%r                     " Options
    " set statusline+=\ [%{&ff}/%Y]                " Filetype
    " set statusline+=\ [%{getcwd()}]              " Current dir
    " set statusline+=%=%-14.(%l,%c%V%)\ %p%%      " Right aligned file nav info

    " statusline {{{
    " highlight StatusLine cterm=bold ctermfg=gray ctermbg=black
    " highlight LineNr ctermfg=gray ctermbg=black                       " 侧边颜色
    " highlight User1 ctermfg=gray
    " highlight User2 ctermfg=green
    " highlight User3 ctermfg=red
    " highlight User4 ctermfg=yellow
    " highlight User5 ctermfg=black
    " highlight User6 ctermfg=blue
    " highlight User7 ctermbg=black
    " set statusline=%7*\ %3*%{HasPaste()}%*[file:\ %2*%t%r%h%w%*]%3*%m%*[dir:\ %<%2*%{CurDir()}%*]%=\ \ \ \ \ \ \ \ \ \ %4*[%{&ff}][%{&encoding}]%6*%y%*[Line:%2*%l%*/%2*%L%*,Column:%2*%c%*][%2*%p%%%*]

    " au InsertEnter * call InsertStatuslineColor('i')
    " au InsertLeave * call InsertStatuslineColor('')
    " statusline end }}}

endif

set backspace=indent,eol,start            " Backspace for dummies
set linespace=0                           " No extra spaces between rows
if !exists('g:evervim_hybrid_linenumber')
    set number                            " Line numbers on
else
    set relativenumber
    set number
endif
set showmatch                   " Show matching brackets/parenthesis 高亮显示匹配的括号
set incsearch                   " Find as you type search
set hlsearch                    " Highlight search terms 搜索逐字符高亮
set winminheight=0              " Windows can be 0 line high
set ignorecase                  " Case insensitive search
set smartcase                   " Case sensitive when uc present
set wildmenu                    " Show list instead of just completing
set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
set scrolljump=5                " Lines to scroll when cursor leaves screen
" Workaround for oni issue #395
if !ONI()
    set scrolloff=3             " Minimum lines to keep above and below cursor
endif
if exists('g:evervim_disable_folding')
    set nofoldenable                " 禁止折叠
else
    set foldenable                  " 允许折叠
endif

set list
set listchars=tab:\│\ ,trail:•,extends:#,nbsp:· " Highlight problematic whitespace, tab: ›
if exists('g:evervim_80_column_warning')
    highlight ColorColumn ctermbg=magenta guibg=magenta
    call matchadd('ColorColumn', '\%81v[^\n]', 100)
endif
