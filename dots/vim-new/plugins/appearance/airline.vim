if isdirectory(expand(EverVimBundleDir("vim-airline")))
    set laststatus=2
    if !exists('g:evervim_airline_theme')
        " let g:airline_theme = 'dracula' " 'molokai' 'solarized'
        " let g:airline_theme = 'dark' " 'molokai' 'solarized'
        let g:airline_theme = 'solarized' " 'molokai' 'solarized'
    else
        let g:airline_theme = g:evervim_airline_theme
    endif
    let g:airline#extensions#tabline#enabled = 1
    "let g:airline#extensions#bufferline#enabled = 1
    let g:airline#extensions#tabline#buffer_nr_show = 1
    let g:airline#extensions#tabline#buffer_nr_format = '%s:'
    if !exists('g:evervim_no_patched_fonts')
        " Use the default set of separators with a few customizations
        let g:airline_powerline_fonts = 1
        let g:airline_left_sep=''
        let g:airline_left_alt_sep=''
        let g:airline_right_sep=''
        let g:airline_right_alt_sep=''
        let g:airline#extensions#tabline#left_sep = ""
        let g:airline#extensions#tabline#left_alt_sep = ''
        let g:airline#extensions#tabline#right_sep = ""
        let g:airline#extensions#tabline#right_alt_sep = ''
        let g:airline#extensions#tabline#buffers_label = ''
        let g:airline#extensions#tabline#tabs_label = ''
    endif
endif

" vim-airline {{{
" Set configuration options for the statusline plugin vim-airline.
" Use the powerline theme and optionally enable powerline symbols.
" To use the symbols , , , , , , and .in the statusline
" segments add the following to your .vimrc.before.local file:
"   let g:airline_powerline_fonts=1
" If the previous symbols do not render for you then install a
" powerline enabled font.

" See `:echo g:airline_theme_map` for some more choices
" Default in terminal vim is 'dark'
if isdirectory(expand("~/.vim/bundle/vim-airline-themes/"))
    if !exists('g:airline_powerline_fonts')
        " Use the default set of separators with a few customizations
        let g:airline_left_sep='›'  " Slightly fancier than '>'
        let g:airline_right_sep='‹' " Slightly fancier than '<'
    endif
endif

if 1 && isdirectory(expand("~/.vim/bundle/vim-airline"))
    let g:airline#extensions#tabline#left_sep = ' '
    let g:airline#extensions#tabline#left_alt_sep = '|'
    if !exists('g:airline_symbols')
        let g:airline_symbols = {}
    endif
    let g:airline_symbols.space = "\ua0"
endif
" }}}
