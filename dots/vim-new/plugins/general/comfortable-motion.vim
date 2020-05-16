let g:comfortable_motion_friction = 80.0
let g:comfortable_motion_air_drag = 2.0
nnoremap <silent> <C-d> :call comfortable_motion#flick(20)<CR>
nnoremap <silent> <C-u> :call comfortable_motion#flick(-20)<CR>
nnoremap <silent> <C-f> :call comfortable_motion#flick(20)<CR>
nnoremap <silent> <C-b> :call comfortable_motion#flick(-20)<CR>
let g:comfortable_motion_scroll_down_key = "j"
let g:comfortable_motion_scroll_up_key = "k"
