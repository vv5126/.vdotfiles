let g:NERDShutUp=1
map <C-e> <plug>NERDTreeTabsToggle<CR>
map <F3> :NERDTreeToggle<CR>
map <leader>nf :NERDTreeFind<CR>
nmap <leader>nt :NERDTreeToggle<CR>

let g:NERDTreeWinSize=30
let NERDTreeShowBookmarks=1
let NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$']
let NERDTreeChDirMode=2
let NERDTreeQuitOnOpen=0
let NERDTreeMouseMode=2
let NERDTreeShowHidden=1
let NERDTreeKeepTreeInNewTab=1
let g:NERDTreeUpdateOnWrite = 0
let g:nerdtree_tabs_open_on_gui_startup=0
if !exists('g:evervim_nerdtree_tabs_sync')
    let g:nerdtree_tabs_open_on_new_tab=0
    let g:nerdtree_tabs_synchronize_view=0
endif
let NERDTreeMapOpenRecursively='<C-O>'

" NerdTree git integration
let g:NERDTreeIndicatorMapCustom = {
            \ "Modified"  : "±",
            \ "Staged"    : "⊕",
            \ "Untracked" : "⊱",
            \ "Renamed"   : "➜",
            \ "Unmerged"  : "═",
            \ "Deleted"   : "⋈",
            \ "Dirty"     : "✗",
            \ "Clean"     : "✓",
            \ 'Ignored'   : '∅',
            \ "Unknown"   : "?"
            \ }
let g:NERDTreeShowIgnoredStatus = 1
" map <C-e> <plug>NERDTreeTabsToggle<CR>
" map <leader>e :NERDTreeFind<CR>
" nmap <leader>nt :NERDTreeFind<CR>

" let NERDTreeChDirMode=0
" let NERDTreeQuitOnOpen=1

" Exit Vim if NERDTree is the only window left.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
            \ quit | endif
" Start NERDTree when Vim starts with a directory argument.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
            \ execute 'NERDTree' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | endif
