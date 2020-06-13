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
nnoremap <leader>df :vert diffsplit 
nnoremap <leader>dff :diffoff<cr>

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

