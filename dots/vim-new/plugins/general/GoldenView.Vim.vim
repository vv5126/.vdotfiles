if isdirectory(expand(EverVimBundleDir('GoldenView.Vim')))
    let g:goldenview__enable_default_mapping = 0
    let g:goldenview__enable_at_startup = 0
    " 1. split to tiled windows
    nmap <silent> <C-g>  <Plug>GoldenViewSplit

    " 2. quickly switch current window with the main pane
    " and toggle back
    nmap <silent> <F8>   <Plug>GoldenViewSwitchMain
    nmap <silent> <S-F8> <Plug>GoldenViewSwitchToggle

    " 3. jump to next and previous window
    nmap <silent> <Leader>gn  <Plug>GoldenViewNext
    nmap <silent> <Leader>gp  <Plug>GoldenViewPrevious

    nmap <silent> <Leader>gre <Plug>GoldenViewResize
endif

