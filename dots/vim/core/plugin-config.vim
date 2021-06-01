" Plugin Configuration
function! SourceConfigsIn(dir)
    let filelist = split(globpath(a:dir, '**/*.vim'), '\n')
    for vimconf in filelist
        let l:plugname = substitute(vimconf, '.*/', '', '')
        let l:plugname1 = substitute(l:plugname, '\.vim$', '', '')

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

let $save_dir = chdir($evervim_root. "/plugins")
if $save_dir != ""
    for $bundle_group in g:evervim_bundle_groups
        let $f = finddir($bundle_group, "**")
        if $f != ""
            call SourceConfigsIn($evervim_root . "/plugins/" . $f)
        endif
    endfor
    call chdir($save_dir)
endif

if 0
let $save_dir = chdir($evervim_root. "/plugins")
if $save_dir != ""
    for $plug in g:plugs_order
        " echom 'load ' . $plug
        " let plugname = substitute($plug, '.*/', '', '')
        let plugname = substitute($plug, '\.vim$', '', '')
        " echom 'plugname = ' . plugname

        let $f = findfile(plugname . ".vim", "**")
        if $f != ""
            if isdirectory(expand(EverVimBundleDir($plug)))
                \ || isdirectory(expand(EverVimBundleDir($plug. '.vim')))
                let vimconf = $evervim_root. "/plugins/" . $f
                " echom 'load ' . vimconf

                " source $f
                execute 'source' vimconf
            else
                echom 'miss ' . $f
            endif
        endif
    endfor
    call chdir($save_dir)
endif
endif
