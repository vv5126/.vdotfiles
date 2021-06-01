
source $evervim_root/core/plug.vim

function! s:evervim_disable_plugin(repo)
    let repo = substitute(a:repo, '[\/]\+$', '', '')
    let name = fnamemodify(repo, ':t:s?\.git$??')
    call remove(g:plugs, name)
    call remove(g:plugs_order, index(g:plugs_order, name))
endfunction

command! -nargs=1 -bar UnPlug call s:evervim_disable_plugin(<args>)


call plug#begin("$evervim_root/bundle")

let $save_dir = chdir($evervim_root. "/plugins")
if $save_dir != ""
    for $bundle_group in g:evervim_bundle_groups
        let $f = findfile($bundle_group . ".bundles", "**")
        if $f != ""
            source $f
        endif
    endfor
    call chdir($save_dir)
endif

" Make sure we run devicons after the above
if !TERMUX() && !exists('g:evervim_no_patched_fonts')
    Plug 'ryanoasis/vim-devicons'
endif

call plug#end()
