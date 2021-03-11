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


" 刷新插件
nmap <F6> :PlugStatus<cr>
" 更新插件
nmap <S-F6> :PlugInstall<cr>

" 空格键替换为换行
" nnoremap <S-k> :s/ \+/\r/g<cr>:noh<cr>
vnoremap <S-k> :s/ \+/\r/g<cr>:noh<cr>

"使用<leader>空格来取消搜索高亮
nnoremap <silent> <leader><space> :noh<cr>:pclose<cr>

"去空行
nnoremap <leader>db :g/^\s*$/d<cr>

"清除末尾空格
nnoremap <leader>ds :%s/\s\+$//<cr>
nmap fk :1,$s/ *$//g<cr>

"函数内排版
nmap = =a{

"清除选中行中所有空格
nnoremap <leader>dd :s/[ \t]\{1,}//g<cr>:noh<cr>
vnoremap <leader>dd :s/[ \t]\{1,}//g<cr>:noh<cr>

"清除选中行中空格,保留一个
nnoremap <leader>d1 :s/[ \t]\{1,}/ /g<cr>:noh<cr>
vnoremap <leader>d1 :s/[ \t]\{1,}/ /g<cr>:noh<cr>

" 切换目录
noremap <leader>1 :execute "cd" expand("%:h")<CR>:execute 'pwd'<cr>
noremap <leader>2 :call GO_GIT_DIR()<cr>

"删除行尾的一个^M
nmap dm :%s/\r\+$//e<cr>:set ff=unix<cr>
" noremap <Leader>m2 mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm
" noremap <Leader>ff :%s/\\\$//g<cr>:%s/\\\/ /g<cr>

"esc的映射
imap jj <esc>

" 好用的复制、粘贴
vmap <C-c> "+y
imap <C-v> <Esc>"*pa
vnoremap <silent> y y`]
vnoremap <silent> p p`]
nnoremap <silent> p p`]

" Switching between buffers.
" nnoremap <C-x> <c-w>\|<c-w>_

" 为选中代码加括号啥的
vnoremap 1 h<esc>`>a)<esc>`<i(<esc>
" vnoremap 2 h<esc>`>a]<esc>`<i[<esc> 'bug for vv'
vnoremap 3 h<esc>`>a}<esc>`<i{<esc>
vnoremap 4 h<esc>`>a"<esc>`<i"<esc>
vnoremap 5 h<esc>`>a'<esc>`<i'<esc>

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


