" let g:fzf_layout = { 'down': '~40%' }
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }

nnoremap <C-P> :History<CR>

nnoremap <Leader>lf :Files<CR>
nnoremap <Leader>ll :Lines<CR>
nnoremap <Leader>lt :Tags<CR>
nnoremap <Leader>lb :Buffers<CR>
nnoremap <Leader>lc :Commands<CR>
nnoremap <Leader>lw :Windows<CR>
nnoremap <Leader>la :Ag<CR>
nnoremap <Leader>lg :GitFiles<CR>
nnoremap <Leader>lo :Locate<Space>
nnoremap <Leader>lm :Maps<CR>
nnoremap <Leader>lh :History<CR>
nnoremap <Leader>ls :Snippets<CR>
nnoremap <Leader>li :Commits<CR>
nnoremap <Leader>lr :Colors<CR>
nnoremap <Leader>le :Helptags<CR>
nnoremap <Leader>..c :BCommits<CR>
nnoremap <Leader>..t :BTags<CR>
nnoremap <Leader>..l :BLines<CR>

if isdirectory(expand(EverVimBundleDir('lightline.vim')))
    autocmd! User FzfStatusLine call lightline#update_once()
endif

" Enable per-command history
" - History files will be stored in the specified directory
" - When set, CTRL-N and CTRL-P will be bound to 'next-history' and
"   'previous-history' instead of 'down' and 'up'.
let g:fzf_history_dir = '~/.local/share/fzf-history'

