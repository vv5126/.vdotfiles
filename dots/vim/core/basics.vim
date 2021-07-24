" Basics
set nocompatible        " Must be first line
if !WINDOWS()
    set shell=/bin/bash
    if ANDROID()
        set shell=/system/bin/sh
    endif
endif

" Arrow Key Fix
if &term[:4] == "xterm" || &term[:5] == 'screen' || &term[:3] == 'rxvt'
    inoremap <silent> <C-[>OC <RIGHT>
endif

function! InitializeDirectories()
    let parent = $XDG_CACHE_HOME . '/vim'
    let prefix = 'vim'
    let dir_list = {
                \ 'backup': 'backupdir',
                \ 'views': 'viewdir',
                \ 'swap': 'directory' }

    if has('persistent_undo')
        let dir_list['undo'] = 'undodir'
    endif

    if exists('g:evervim_consolidated_directory')
        let common_dir = g:evervim_consolidated_directory . prefix
    else
        let common_dir = parent . '/.' . prefix
    endif

    for [dirname, settingname] in items(dir_list)
        let directory = common_dir . dirname . '/'
        if exists("*mkdir")
            if !isdirectory(directory)
                call mkdir(directory)
            endif
        endif
        if !isdirectory(directory)
            echo "Warning: Unable to create backup directory: " . directory
            echo "Try: mkdir -p " . directory
        else
            let directory = substitute(directory, " ", "\\\\ ", "g")
            exec "set " . settingname . "=" . directory
        endif
    endfor
endfunction

function! EverVimBundleDir(bundlename)
    return $evervim_root . "/bundle/" . a:bundlename
endfunction

call InitializeDirectories()

