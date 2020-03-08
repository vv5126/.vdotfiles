if 1 && isdirectory(expand("~/.vim/bundle/vim-easymotion"))
    " nmap t <Plug>(easymotion-t2)
    map  ? <Plug>(easymotion-sn)
    omap ? <Plug>(easymotion-tn)
    " map  n <Plug>(easymotion-next)
    " map  N <Plug>(easymotion-prev)
    map <Leader>l <Plug>(easymotion-lineforward)
    map <Leader>j <Plug>(easymotion-j)
    map <Leader>k <Plug>(easymotion-k)
    map <Leader>h <Plug>(easymotion-linebackward)
    let g:EasyMotion_startofline = 0 " keep cursor column when JK motion

    let g:EasyMotion_do_mapping = 0 " Disable default mappings
    " Bi-directional find motion
    " Jump to anywhere you want with minimal keystrokes, with just one key
    " binding.
    " `s{char}{label}`
    nmap s <Plug>(easymotion-s)
    " or
    " `s{char}{char}{label}`
    " Need one more keystroke, but on average, it may be more comfortable.
    nmap s <Plug>(easymotion-s2)
    " Turn on case insensitive feature
    let g:EasyMotion_smartcase = 1
endif
