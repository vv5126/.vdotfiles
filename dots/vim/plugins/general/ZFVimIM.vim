if 1
    function! s:myLocalDb()
        let db = ZFVimIM_dbInit({
                    \   'name' : 'vv-pinyin',
                    \ })
        call ZFVimIM_cloudRegister({
                    \   'mode' : 'local',
                    \   'dbId' : db['dbId'],
                    \   'repoPath' : $evervim_root . '/plugins/general',
                    \   'dbFile' : '/pinyin.txt',
                    \   'dbCountFile' : '/pinyin_count.txt',
                    \ })
    endfunction
    autocmd User ZFVimIM_event_OnDbInit call s:myLocalDb()
else
    let g:zf_git_user_email='wei.gao@ingenic.com'
    let g:zf_git_user_name='Gao Wei'
    " let g:zf_git_user_token='4825670a96d679b0a093f7f909641757'
    let g:zf_git_user_token='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'
endif

" let g:ZFVimIM_autoAddWordLen=3*4
" when you choose word and the word's byte length less than this value, we would add the word to db file automatically (ignored when g:ZFVimIM_autoAddWordChecker is set)

" let g:ZFVimIM_autoAddWordChecker=[]
" list of function to check whether need to add user word

" function! MyChecker(userWord)
"     let needAdd = ...
"     return needAdd
" endfunction
" let g:ZFVimIM_autoAddWordChecker=[function('MyChecker')]
" when any of checker returned 0, we won't add user word

" let g:ZFVimIM_symbolMap = {}
" used to transform unicode symbols during input
" it's empty by default, typical config for Chinese:
" let g:ZFVimIM_symbolMap = {
"             \   ' ' : [''],
"             \   '`' : ['·'],
"             \   '!' : ['！'],
"             \   '$' : ['￥'],
"             \   '^' : ['……'],
"             \   '-' : [''],
"             \   '_' : ['——'],
"             \   '(' : ['（'],
"             \   ')' : ['）'],
"             \   '[' : ['【'],
"             \   ']' : ['】'],
"             \   '<' : ['《'],
"             \   '>' : ['》'],
"             \   '\' : ['、'],
"             \   '/' : ['、'],
"             \   ';' : ['；'],
"             \   ':' : ['：'],
"             \   ',' : ['，'],
"             \   '.' : ['。'],
"             \   '?' : ['？'],
"             \   "'" : ['‘', '’'],
"             \   '"' : ['“', '”'],
"             \   '0' : [''],
"             \   '1' : [''],
"             \   '2' : [''],
"             \   '3' : [''],
"             \   '4' : [''],
"             \   '5' : [''],
"             \   '6' : [''],
"             \   '7' : [''],
"             \   '8' : [''],
"             \   '9' : [''],
"             \ }
" note, if you want to change this setting at runtime, you should use call ZFVimIME_stop() | call ZFVimIME_start() to restart to take effect, or, add autocmd to ZFVimIM_event_OnStart to setup this value

" let g:ZFVimIM_cachePath=$HOME.'/.vim_cache/ZFVimIM'
" cache path for temp files

" let g:ZFVimIM_cloudAsync_outputTo={...}
" for async cloud input, output log to where (see ZFJobOutput), default:

" let g:ZFVimIM_cloudAsync_outputTo = {
"             \   'outputType' : 'statusline',
"             \   'outputId' : 'ZFVimIM_cloud_async',
"             \ }

" let g:ZFVimIM_cloudAsync_autoCleanup=30
" your db repo may contain many commits after long time usage, we would try to remove all history commits if:

" ZFJobAvailable() returned 1 (i.e. async mode available)
" g:ZFVimIM_cloudAsync_autoCleanup greater than 0
" your git rev-list --count HEAD exceeds g:ZFVimIM_cloudAsync_autoCleanup

" NOTE:
" this require you have git push --force permission, if not, please disable this feature, otherwise your commits may lost occasionally (each time when commits exceeds g:ZFVimIM_cloudAsync_autoCleanup)

" let g:ZFVimIM_cloudAsync_autoInit=1
" for async cloud input only, when on, we would load db when VimEnter, to reduce the time you first ZFVimIME_start()

" ;; 开启或关闭输入法, ;: 切换词库
" - 和 = 翻页
" 空格 和 0~9 选词或组词
" [ 和 ] 快速从词组选字
" 输入过程中会自动组自造词, 也可以用 ;, 或 :IMAdd 手动添加自造词, ;. 或 :IMRemove 删除自造词 
