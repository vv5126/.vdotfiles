noremap <Leader>fm :Autoformat<CR>
if !exists('g:evervim_no_autoformat')
    au BufWrite *.c,*.cpp,*.h,*.hpp,*.cxx :Autoformat
    au BufWrite *.rust,*.rs :Autoformat
    au BufWrite *.cs :Autoformat
    au BufWrite *.java :Autoformat
    au BufWrite *.py :Autoformat
    au BufWrite *.css :Autoformat
    au BufWrite *.ts :Autoformat
endif

set pyxversion=3 " 或 set pyxversion=2
let g:python3_host_prog = "/backup/home/wgao/.local/tools/miniconda3/envs/p3/bin/python3"
