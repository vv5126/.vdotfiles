if isdirectory(expand(EverVimBundleDir('ultisnips')))
    let g:UltiSnipsEditSplit="vertical"

    " remap Ultisnips for compatibility for YCM
    let g:UltiSnipsExpandTrigger = "<Leader><Tab>"
    let g:UltiSnipsJumpForwardTrigger = "<Tab>"
    let g:UltiSnipsJumpBackwardTrigger = "<S-Tab>"
    " let g:UltiSnipsExpandTrigger = '<C-j>'
    " let g:UltiSnipsExpandTrigger = "<Plug>(ultisnips_expand)"
endif
