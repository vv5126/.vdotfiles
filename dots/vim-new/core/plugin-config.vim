" Plugin Configuration 
function! SourceConfigsIn(dir)
    let filelist = split(globpath(a:dir, '*.vim'), '\n')
    for vimconf in filelist
        let l:plugname = substitute(vimconf, '.*/', '', '')
        let l:plugname1 = substitute(l:plugname, '.vim$', '', '')

        if count(g:plugs_order, l:plugname1) != 0
            \ || count(g:plugs_order, l:plugname1 . '.vim') != 0
            if isdirectory(expand(EverVimBundleDir(l:plugname)))
                \ || isdirectory(expand(EverVimBundleDir(l:plugname1)))
                " echo 'load ' . vimconf
                execute 'source' vimconf
            else
                echo 'miss ' . vimconf
            endif
        " else
        "     echo 'unload ' . vimconf
        endif

        if a:dir == expand($evervim_root . '/plugins/v')
            execute 'source' vimconf
        endif
    endfor
endfunction

for $bundle_group in g:evervim_bundle_groups
    " search all *.vim at same dir of bundle.
    call SourceConfigsIn($evervim_root . "/plugins/" . $bundle_group)
endfor
