
" Setup Vim-Plug Support {
    source $evervim_root/core/plug.vim
    call plug#begin(EverVimBundleDir(''))
" }

" Bundles {

    " list only the bundle groups you will use
    if !exists('g:evervim_bundle_groups')
        if WINDOWS()
            let g:evervim_bundle_groups=['general', 'appearance', 'writing', 'neocomplete', 'programming', 'python', 'javascript', 'typescript', 'html', 'css', 'misc', 'go', 'rust', 'cpp', 'lua']
        else
            let g:evervim_bundle_groups=['general', 'appearance', 'writing', 'youcompleteme', 'programming', 'python', 'javascript', 'typescript', 'html', 'css', 'misc', 'go', 'rust', 'cpp', 'lua']
        endif
    endif

    if exists('g:override_evervim_bundles')
        " Disable a specific plugin
        " https://github.com/junegunn/vim-plug/issues/469#issuecomment-226965736
        function! s:evervim_disable_plugin(repo)
          let repo = substitute(a:repo, '[\/]\+$', '', '')
          let name = fnamemodify(repo, ':t:s?\.git$??')
          call remove(g:plugs, name)
          call remove(g:plugs_order, index(g:plugs_order, name))
        endfunction

        command! -nargs=1 -bar UnPlug call s:evervim_disable_plugin(<args>)
    endif

    for $bundle_group in g:evervim_bundle_groups
        " search all *.bundles
        let $f = expand($evervim_root . "/plugins/" . $bundle_group . "/" . substitute($bundle_group, '.*/', '', '') . ".bundles")
        if filereadable($f)
            source $f
        endif
    endfor

    " Use local bundles config if available {
    if exists('g:override_evervim_bundles') && filereadable(expand("~/.EverVim.bundles"))
        source ~/.EverVim.bundles
    endif
    " }
" }

" Vim-Plug Teardown {
    call plug#end()
" }
