" disable the default highlight group
" let g:conflict_marker_highlight_group = 'Error'

" Include text after begin and end markers
" let g:conflict_marker_begin = '^<<<<<<< .*$'
" let g:conflict_marker_end   = '^>>>>>>> .*$'

highlight ConflictMarkerBegin guifg=white guibg=#2f73fe
highlight ConflictMarkerOurs guifg=white guibg=yellow
highlight ConflictMarkerTheirs guifg=white guibg=red
highlight ConflictMarkerEnd guifg=white guibg=#2f628e
let g:conflict_marker_enable_highlight = 1
