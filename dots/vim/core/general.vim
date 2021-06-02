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

" Setting up the directories {
    set backup                  " Backups are nice ...
    if has('persistent_undo')
        set undofile                " 无限undo ...
        set undolevels=1000         " Maximum number of changes that can be undone
        set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
    endif
" }


