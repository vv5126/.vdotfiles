" let g:fzf_layout = { 'down': '~40%' }
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
" let g:fzf_preview_window = ['right:50%', 'ctrl-/']
let g:fzf_preview_window = []

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

"fzf-----------------------------------------------------------------------
function! s:fzf_statusline()
    " Override statusline as you like
    highlight fzf1 ctermfg=161 ctermbg=251
    highlight fzf2 ctermfg=23 ctermbg=251
    highlight fzf3 ctermfg=237 ctermbg=251
    setlocal statusline=%#fzf1#\ >\ %#fzf2#fz%#fzf3#f
endfunction

autocmd! User FzfStatusLine call <SID>fzf_statusline()
" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1
" [[B]Commits] Customize the options used by 'git log':
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'
" [Tags] Command to generate tags file
let g:fzf_tags_command = 'ctags -R'
" [Commands] --expect expression for directly executing the command
let g:fzf_commands_expect = 'alt-enter,ctrl-x'

" let g:fzf_action = { 'ctrl-b': 'edit' }
