if !exists('g:evervim_leader')
    let mapleader = ';'
else
    let mapleader=g:evervim_leader
endif
if !exists('g:evervim_localleader')
    let maplocalleader = '\'
else
    let maplocalleader=g:evervim_localleader
endif

if !exists('g:evervim_edit_config_mapping')
    let s:evervim_edit_config_mapping = '<leader>ec'
else
    let s:evervim_edit_config_mapping = g:evervim_edit_config_mapping
endif
if !exists('g:evervim_apply_config_mapping')
    let s:evervim_apply_config_mapping = '<leader>ac'
else
    let s:evervim_apply_config_mapping = g:evervim_apply_config_mapping
endif

" TODO: edit config not working yet
execute "noremap " . s:evervim_edit_config_mapping . " :tabedit $evervim_root/vimrc<CR>"
execute "noremap " . s:evervim_apply_config_mapping . " :source $evervim_root/vimrc<CR>"

" statusline {{{
highlight StatusLine cterm=bold ctermfg=gray ctermbg=black
highlight LineNr ctermfg=gray ctermbg=black                       " 侧边颜色
highlight User1 ctermfg=gray
highlight User2 ctermfg=green
highlight User3 ctermfg=red
highlight User4 ctermfg=yellow
highlight User5 ctermfg=black
highlight User6 ctermfg=blue
highlight User7 ctermbg=black
set statusline=%7*\ %3*%{HasPaste()}%*[file:\ %2*%t%r%h%w%*]%3*%m%*[dir:\ %<%2*%{CurDir()}%*]%=\ \ \ \ \ \ \ \ \ \ %4*[%{&ff}][%{&encoding}]%6*%y%*[Line:%2*%l%*/%2*%L%*,Column:%2*%c%*][%2*%p%%%*]

au InsertEnter * call InsertStatuslineColor('i')
au InsertLeave * call InsertStatuslineColor('')
" statusline end }}}

" Setting up the directories {
    set backup                  " Backups are nice ...
    if has('persistent_undo')
        set undofile                " 无限undo ...
        set undolevels=1000         " Maximum number of changes that can be undone
        set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
    endif
" }


