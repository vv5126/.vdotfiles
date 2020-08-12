" Functions

" Initialize NERDTree as needed {
function! NERDTreeInitAsNeeded()
    redir => bufoutput
    buffers!
    redir END
    let idx = stridx(bufoutput, "NERD_tree")
    if idx > -1
        NERDTreeMirror
        NERDTreeFind
        wincmd l
    endif
endfunction
" }

" Strip whitespace {
function! StripTrailingWhitespace()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " do the business:
    %s/\s\+$//e
    " clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
" }

" Unix Dos Conversion {
function! VDos2Unix()
    execute 'update | e ++ff=dos | setlocal ff=unix'
    silent %s/\r//ge
    execute 'w'
endfunction

function! VUnix2Dos()
    execute 'update | e ++ff=dos | w'
endfunction
" }

" Shell command {
function! s:RunShellCommand(cmdline)
    botright new

    setlocal buftype=nofile
    setlocal bufhidden=delete
    setlocal nobuflisted
    setlocal noswapfile
    setlocal nowrap
    setlocal filetype=shell
    setlocal syntax=shell

    call setline(1, a:cmdline)
    call setline(2, substitute(a:cmdline, '.', '=', 'g'))
    execute 'silent $read !' . escape(a:cmdline, '%#')
    setlocal nomodifiable
    1
endfunction

command! -complete=file -nargs=+ Shell call s:RunShellCommand(<q-args>)
" e.g. Grep current file for <search_term>: Shell grep -Hn <search_term> %
" }

function! ReplaceInFile(file, regexmatch, replace)
    execute 'args ' . a:file | execute 'argdo %s/' . a:regexmatch . '/' . a:replace . '/gce' | execute 'argdo wq'
endfunction

function! DeleteLinesInFile(file, regexmatch)
    execute 'args ' . a:file . ' | argdo g/' . a:regexmatch . '/d | argdo wq'
endfunction

function! EverVimBundleDir(bundlename)
    return $evervim_root . "/bundle/" . a:bundlename
endfunction

function! EverVimFullUpgrade()
    copen
    cexpr "Running EverVim Full Upgrade ...\n".
                \ "This will take about 2-5 minutes, depending on your network condition.\n" .
                \ "After finish updating, you can try:\n".
                \ "    - press `D` to see the changes for plugins.\n" .
                \ "A restart is **required** after the updating process is finished.\n" . "Enjoy!"
    sleep 1000m
    execute 'PlugUpgrade'
    execute 'PlugClean!'
    execute 'PlugUpdate'
    echo 'Update Completed!'
endfunction
