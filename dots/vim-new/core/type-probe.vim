" 文件类型判断及配置加载 {{{
    let g:filetype_last=''

    function! CHECK_FILETYPE()
        set sh=bash
        if &filetype != g:filetype_last
            if g:filetype_last == 'c' || g:filetype_last == 'cpp'
                call UNSET_FILETYPE_C()
            elseif g:filetype_last == 'sh'
                call UNSET_FILETYPE_SH()
            elseif g:filetype_last == 'vim'
                call UNSET_FILETYPE_VIM()
            endif

            if &filetype == 'c' || &filetype == 'cpp'
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

    function! SET_FILETYPE_C()
        " guess project
        let g:code_project = system("tmp=$(lib.work guess_obj); echo -n ${tmp%% *}")

        " super print
        nnoremap <leader>t :call SuperPrint(1)<CR>
        nnoremap <leader>y :call SuperPrint(0)<CR>

        " 'scrooloose/syntastic 语法检查'
        "  let g:syntastic_check_on_open=0
        " let g:syntastic_auto_loc_list = 1
        "  let g:syntastic_check_on_wq = 0
        " let syntastic_loc_list_height = 5
        let g:shiftwidth=8
        let g:tabstop=8
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
        nmap <Leader>dp :g/printf(\"\\033\[*/d<cr>
        " nmap  <F1> :copen<cr>:AsyncRun mk ycm_conf<cr>
        nmap  <F1> :let g:asyncrun_exit = 'call Mktagexit()'<cr>:AsyncRun mk -t<cr>:echo 'uptag ...'<cr>
        nmap  <F2> :call Burn_on()<cr>
        nmap  <F3> :call Burn_off()<cr>
        nmap  <F4> :call Run_mk()<cr>
        nmap  <F5> :cclose<cr>
        " -------------------------------------------------
        if g:code_project == 'kernel'
            set noexpandtab           " 不要用空格代替制表符
            iab wgao1 <c-r>='printk("\033[33m(l:%d, f:%s, F: %s) %d %s\033[0m\n", __LINE__, __func__, __FILE__, 0, "");'<cr>
            iab wgao2 <c-r>='printk("\033[33m(l:%d, f:%s, F: %s) %d %s\033[0m\n", __LINE__, __func__, __FILE__, 0, "");'<cr>
            " iab wgao1 <c-r>='printk("\033[33m(l:%d, f:%s, F:%s, p:%d) %d %s\033[0m\n", __LINE__, __func__, __FILE__, current->pid, 0, "");'<cr>
        else
            iab wgao1 <c-r>='printf("\033[33m(l:%d, f:%s, F: %s) %d %s\033[0m\n", __LINE__, __func__, __FILE__, 0, "");'<cr>
            iab wgao2 <c-r>='printf("\033[33m(l:%d, f:%s, F: %s) %d %s\033[0m\n", __LINE__, __func__, __FILE__, 0, "");'<cr>
            " iab wgao2 <c-r>='printf("\033[33m(l:%d, f:%s, F:%s, p:%d) %d %s\033[0m\n", __LINE__, __func__, __FILE__, current->pid, 0, "");'<cr>
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

    function! SET_FILETYPE_SH()
        let g:shiftwidth=4
        let g:tabstop=4
    endfunction

    function! UNSET_FILETYPE_SH()
    endfunction

    function! SET_FILETYPE_VIM()
        let g:shiftwidth=4
        let g:tabstop=4
    endfunction

    function! UNSET_FILETYPE_VIM()
    endfunction

" 文件类型判断及配置加载 end }}}


" Formatting
" 以后全更新到探测中

set nowrap                      " Do not wrap long lines
set autoindent                  " Indent at the same level of the previous line
set shiftwidth=4                " Use indents of 4 spaces
set expandtab                   " 用空格代替制表符
set tabstop=4                   " 设置编辑时制表符占用空格数
set softtabstop=4               " 让 vim 把连续数量的空格视为一个制表符, 使得按退格键时可以一次删掉 4 个空格
set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)
set splitright                  " Puts new vsplit windows to the right of the current
set splitbelow                  " Puts new split windows to the bottom of the current
"set matchpairs+=<:>            "  Match, to be used with %
set pastetoggle=<F12>           "  pastetoggle (sane indentation on pastes)
set autoread                    " 设置当文件被改动时自动载入
if OSX()
    set nofsync                 " Disable fsync under macOS, for it wont work on NTFS
endif
"set comments=sl:/*,mb:*,elx:*/ "  auto format comment blocks
" Remove trailing whitespaces and ^M chars
" To disable the stripping of whitespace, add the following to your
" .vimrc.before.local file:
"   let g:evervim_keep_trailing_whitespace = 1
autocmd FileType c,cpp,java,go,php,javascript,puppet,python,rust,twig,xml,yml,yaml,perl,sql autocmd BufWritePre <buffer> if !exists('g:evervim_keep_trailing_whitespace') | call StripTrailingWhitespace() | endif
"autocmd FileType go autocmd BufWritePre <buffer> Fmt
autocmd BufNewFile,BufRead *.html.twig set filetype=html.twig
autocmd FileType haskell,puppet,ruby,yml,yaml setlocal expandtab shiftwidth=2 softtabstop=2
autocmd FileType html,xml,gohtmltmpl setlocal expandtab shiftwidth=2 softtabstop=2
autocmd FileType typescript setlocal expandtab shiftwidth=4 softtabstop=4
" preceding line best in a plugin but here for now.

autocmd BufNewFile,BufRead *.bundles set filetype=vim
