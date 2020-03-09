if isdirectory(expand(EverVimBundleDir('incsearch.vim')))
    " 会造成/不好用
    " map /  <Plug>(incsearch-forward)
    " map ?  <Plug>(incsearch-backward)
    " map g/ <Plug>(incsearch-stay)
endif
if isdirectory(expand(EverVimBundleDir('vim-over')))
    let g:over_command_line_prompt = "IncReplace > "
    map <Leader>sr :OverCommandLine<CR>%s/
endif
