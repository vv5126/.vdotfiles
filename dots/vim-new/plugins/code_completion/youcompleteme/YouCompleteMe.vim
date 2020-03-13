if count(g:evervim_bundle_groups, 'youcompleteme')
    let g:acp_enableAtStartup = 0

    " enable completion from tags
    " 开启 YCM 标签补全引擎
    let g:ycm_collect_identifiers_from_tags_files = 1

    " load ycm global config
    let g:ycm_global_ycm_extra_conf = $evervim_root . "/plugins/youcompleteme/ycm_global_conf.py"

    " YouCompleteMe keymap
    let g:ycm_key_detailed_diagnostics = '<leader>yd'

    " YcmCompleter GoTo keymap
    nnoremap <leader>ygd :YcmCompleter GoToDefinition<CR>
    nnoremap <leader>ydc :YcmCompleter GoToDeclaration<CR>
    nnoremap <leader>ygt :YcmCompleter GoTo<CR>

    " Enable omni completion.
    autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
    autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
    autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
    autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
    autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc

    " Haskell post write lint and check with ghcmod
    " $ `cabal install ghcmod` if missing and ensure
    " ~/.cabal/bin is in your $PATH.
    if !executable("ghcmod")
        autocmd BufWritePost *.hs GhcModCheckAndLintAsync
    endif

    " For snippet_complete marker.
    if !exists("g:evervim_no_conceal")
        if has('conceal')
            set conceallevel=2 concealcursor=i
        endif
    endif

    " Disable the neosnippet preview candidate window
    " When enabled, there can be too much visual noise
    " especially when splits are used.
    " 补全内容不以分割子窗口形式出现，只显示补全列表
    set completeopt-=preview

    " Enable markdown autocomplete and snippet
    " by removing it from default blacklist
    let g:ycm_filetype_blacklist = {
                \ 'tagbar' : 1,
                \ 'qf' : 1,
                \ 'notes' : 1,
                \ 'unite' : 1,
                \ 'text' : 1,
                \ 'vimwiki' : 1,
                \ 'pandoc' : 1,
                \ 'infolog' : 1,
                \ 'mail' : 1
                \}
endif

    "**
    " 首次使用步骤:
    " 1. 获取 YCM 的依赖包
    "    cd ~/.vim/bundle/YouCompleteMe/
    "    git submodule update --init --recursive
    "    follow the README.md 保证安装好cmake
    " 2. ./install.py --clang-completer
    " 3. done
    " 如果失败就使用下面的方法
    " 2. 在 http://llvm.org/releases/download.html 找到最新版 LLVM，在Pre-built Binaries
    "    下选择适合你发行套件的最新版预编译二进制文件，下载并解压至 ~/xxx/clang+llvm,这里最好将bin目录添加到环境变量，以后有用。
    " 3. mkdir and cd ~/ycm_build
    "    cmake -G "Unix Makefiles" -DPATH_TO_LLVM_ROOT=~/xxx/clang+llvm/ . ~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp
    "    make ycm_support_libs
    "    cmake -G "Unix Makefiles" . ~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp
    " 4. done
    " ------------------>>> may be need install python-dev
    "*/
if 1 && isdirectory(expand("~/.vim/bundle/YouCompleteMe"))
    "**
    " 首次使用步骤:
    " 1. 获取 YCM 的依赖包
    "    cd ~/.vim/bundle/YouCompleteMe/
    "    git submodule update --init --recursive
    "    follow the README.md 保证安装好cmake
    " 2. ./install.py --clang-completer
    " 3. done
    " 如果失败就使用下面的方法
    " 2. 在 http://llvm.org/releases/download.html 找到最新版 LLVM，在Pre-built Binaries
    "    下选择适合你发行套件的最新版预编译二进制文件，下载并解压至 ~/xxx/clang+llvm,这里最好将bin目录添加到环境变量，以后有用。
    " 3. mkdir and cd ~/ycm_build
    "    cmake -G "Unix Makefiles" -DPATH_TO_LLVM_ROOT=~/xxx/clang+llvm/ . ~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp
    "    make ycm_support_libs
    "    cmake -G "Unix Makefiles" . ~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp
    " 4. done
    " ------------------>>> may be need install python-dev
    "*/

    nnoremap <F1> :YcmForceCompileAndDiagnostics<CR>
    let g:syntastic_always_populate_loc_list = 1
    let g:ycm_always_populate_location_list =1

    " 菜单
    highlight Pmenu ctermfg=3 ctermbg=black guifg=#005f87 guibg=#EEE8D5
    " 选中项
    highlight PmenuSel ctermfg=green ctermbg=black guifg=#AFD700 guibg=#106900
    " 补全功能在注释中同样有效
    let g:ycm_complete_in_comments=1
    " 允许 vim 加载 .ycm_extra_conf.py 文件，不再提示
    let g:ycm_confirm_extra_conf=0
    " 引入 C++ 标准库tags
    "set tags+=/data/misc/software/misc./vim/stdcpp.tags
    " YCM 集成 OmniCppComplete 补全引擎，设置其快捷键
    "inoremap <leader>; <C-x><C-o>
    " 从第一个键入字符就开始罗列匹配项
    let g:ycm_min_num_of_chars_for_completion=2
    " 禁止缓存匹配项，每次都重新生成匹配项
    let g:ycm_cache_omnifunc=0
    " 语法关键字补全
    let g:ycm_seed_identifiers_with_syntax=0
    " 收集所有词条
    let g:ycm_collect_identifiers_from_comments_and_strings = 1
    " 关闭语法检查
    let g:ycm_register_as_syntastic_checker = 0

    let g:ycm_auto_trigger = 1
    " let g:ycm_semantic_triggers = {}
    " let g:ycm_semantic_triggers.c = ['->', '.', ' ', '(', '[', '&']

    let g:syntastic_enable_highlighting = 0

    " nnoremap <leader>gl :YcmCompleter GoToDeclaration<CR>
    nnoremap <leader>gf :YcmCompleter GoToDefinition<CR>
    nnoremap <leader>gl :YcmCompleter GoToDefinitionElseDeclaration<CR>
    " nmap <F3> :YcmDiags<CR>

    " let g:UltiSnipsSnippetDirectories=[$HOME.'/.vim/bundle/wim/UltiSnips']

    let g:ycm_filetype_blacklist = {
                \ 'markdown' : 1,
                \ 'vimwiki' : 1,
                \ 'gitcommit' : 1,
                \}

    " 影响回车
    let g:UltiSnipsExpandTrigger="<TAB>"
    let g:UltiSnipsJumpForwardTrigger="<c-j>"
    let g:UltiSnipsJumpBackwardTrigger="<c-k>"
    au InsertEnter * exec "inoremap <silent> " . g:UltiSnipsExpandTrigger . " <C-R>=g:UltiSnips_Complete()<cr>"
    au InsertEnter * exec "inoremap <silent> " . g:UltiSnipsJumpBackwardTrigger . " <C-R>=g:UltiSnips_Reverse()<cr>"
endif
