" 列出当前打开的buffer,可以很容易的切换到和删除选定的buffer,必备插件之一
" \be 全屏方式查看全部打开的文件列表
" \bv 左右方式查看   \bs 上下方式查看
let g:bufExplorerDefaultHelp=0
let g:bufExplorerShowRelativePath=1
let g:bufExplorerSortBy = "name"
map <leader>o :BufExplorer<cr>
