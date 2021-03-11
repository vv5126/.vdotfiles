function! ReplaceInFile(file, regexmatch, replace)
    execute 'args ' . a:file | execute 'argdo %s/' . a:regexmatch . '/' . a:replace . '/gce' | execute 'argdo wq'
endfunction

function! DeleteLinesInFile(file, regexmatch)
    execute 'args ' . a:file . ' | argdo g/' . a:regexmatch . '/d | argdo wq'
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




" useful function, usage, :call xxx.

VDos2Unix()
VUnix2Dos()
EverVimInitPlugins()


" Run PlugInstall if bundle does not exists
" autocmd VimEnter * call EverVimInitPlugins()

" function! s:ExpandFilenameAndExecute(command, file)
"     execute a:command . " " . expand(a:file, ":p")
" endfunction

" function! EditEverVimConfig()
"     call <SID>ExpandFilenameAndExecute("tabedit", "~/.vim/vimrc")
" endfunction

" function! EverVimUpdateConfig()
"     if WINDOWS()
"         execute '!git -C \%USERPROFILE\%/.EverVim pull'
"     else
"         execute '!git -C '. $evervim_root . ' pull'
"     endif
"     execute "source " . $evervim_root . "/vimrc"
" endfunction

