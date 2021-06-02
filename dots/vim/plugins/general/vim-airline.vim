if !exists('g:evervim_airline_theme')
    let g:airline_theme = 'solarized'
else
    let g:airline_theme = g:evervim_airline_theme
endif

let g:airline#extensions#tabline#buffer_nr_show = 0
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

let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_symbols.space = "\ua0"
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
" }}}
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline_statusline_ontop=1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#coc#enabled = 0
let g:airline#extensions#whitespace#enabled = 0

" let g:airline#extensions#ale#enabled = 0
" let g:airline#extensions#battery#enabled = 0
" let g:airline#extensions#bookmark#enabled = 0
" let g:airline#extensions#branch#enabled = 0
" let g:airline#extensions#bufferline#enabled = 0
" let g:airline#extensions#capslock#enabled = 0
" let g:airline#extensions#csv#enabled = 0
" let g:airline#extensions#ctrlspace#enabled = 0
" let g:airline#extensions#cursormode#enabled = 0
" let g:airline#extensions#denite#enabled = 0
" let g:airline#extensions#dirvish#enabled = 0
" let g:airline#extensions#eclim#enabled = 0
" let g:airline#extensions#fern#enabled = 0
" let g:airline#extensions#fugitiveline#enabled = 0
" let g:airline#extensions#fzf#enabled = 0
" let g:airline#extensions#gina#enabled = 0
" let g:airline#extensions#grepper#enabled = 0
" let g:airline#extensions#gutentags#enabled = 0
" let g:airline#extensions#gen_tags#enabled = 0
" let g:airline#extensions#hunks#enabled = 0
" let g:airline#extensions#keymap#enabled = 0
" let g:airline#extensions#languageclient#enabled = 0
" let g:airline#extensions#localsearch#enabled = 0
" let g:airline#extensions#lsp#enabled = 0
" let g:airline#extensions#neomake#enabled = 0
" let g:airline#extensions#nrrwrgn#enabled = 0
" let g:airline#extensions#nvimlsp#enabled = 0
" let g:airline#extensions#obsession#enabled = 0
" let g:airline#extensions#omnisharp#enabled = 0
" let g:airline#extensions#po#enabled = 0
" let g:airline#extensions#poetv#enabled = 0
" let g:airline#extensions#promptline#enabled = 0
" let g:airline#extensions#searchcount#enabled = 0
" let g:airline#extensions#syntastic#enabled = 0
" let g:airline#extensions#scrollbar#enabled = 0
" let g:airline#extensions#taboo#enabled = 0
" let g:airline#extensions#term#enabled = 0
" let g:airline#extensions#tabws#enabled = 0
" let g:airline#extensions#tagbar#enabled = 0
" let g:airline#extensions#tmuxline#enabled = 0
" let g:airline#extensions#unite#enabled = 0
" let g:airline#extensions#vimagit#enabled = 0
" let g:airline#extensions#vimcmake#enabled = 0
" let g:airline#extensions#vimtex#enabled = 0
" let g:airline#extensions#virtualenv#enabled = 0
" let g:airline#extensions#vista#enabled = 0
" let g:airline#extensions#windowswap#enabled = 0
" let g:airline#extensions#wordcount#enabled = 0
" let g:airline#extensions#xkblayout#enabled = 0
" let g:airline#extensions#ycm#enabled = 0
" let g:airline#extensions#zoomwintab#enabled = 0

function! AirlineInit()
    let spc = g:airline_symbols.space
    let g:airline_section_a = airline#section#create_left(['mode', 'crypt', 'paste', 'keymap', 'spell', 'capslock', 'xkblayout', 'iminsert'])
    " let g:airline_section_b = airline#section#create(['hunks', 'branch', 'battery'])
    let g:airline_section_b = airline#section#create(['hunks', 'branch'])
    " let g:airline_section_b = '%{strftime("%c")}'
    if exists("+autochdir") && &autochdir == 1
        let g:airline_section_c = airline#section#create(['%<', 'path', spc, 'readonly', 'coc_status', 'lsp_progress'])
    else
        let g:airline_section_c = airline#section#create(['%<', 'file', spc, 'readonly', 'coc_status', 'lsp_progress'])
    endif
    let g:airline_section_gutter = airline#section#create(['%='])
    let g:airline_section_x = airline#section#create_right(['coc_current_function', 'bookmark', 'scrollbar', 'tagbar', 'vista', 'gutentags', 'gen_tags', 'omnisharp', 'grepper', 'filetype'])
    let g:airline_section_y = airline#section#create_right(['ffenc'])
    let g:airline_section_z = airline#section#create(['%p%%', 'linenr', 'colnr'])
    let g:airline_section_z = airline#section#create([''])
    let g:airline_section_error = airline#section#create(['ycm_error_count', 'syntastic-err', 'eclim', 'neomake_error_count', 'ale_error_count', 'lsp_error_count', 'nvimlsp_error_count', 'languageclient_error_count', 'coc_error_count'])
    let g:airline_section_warning = airline#section#create(['ycm_warning_count',  'syntastic-warn', 'neomake_warning_count', 'ale_warning_count', 'lsp_warning_count', 'nvimlsp_warning_count', 'languageclient_warning_count', 'whitespace', 'coc_warning_count'])
endfunction

function! MyAppend2(...)
  call a:1.add_section('airline_a', ' %t ')
  call a:1.add_section('airline_b', ' lsdjflsdjfsjdf ')
  call a:1.add_section('airline_c',     ' my ')
  " call a:1.add_section('airline_d',     ' my ')
  " call a:1.add_section('airline_e',     ' my ')
  " call a:1.add_section('airline_y', ' all ')
  " call a:1.add_section('airline_z',      ' all ')
  " call a:1.add_section('airline_y', spc.'%{fern#comparator}'.spc)
  call a:1.split()
  return 1
endfunction

" call airline#add_statusline_func('MyAppend2')
autocmd VimEnter * call AirlineInit()
" autocmd VimEnter * call airline#add_statusline_func('MyAppend2')
