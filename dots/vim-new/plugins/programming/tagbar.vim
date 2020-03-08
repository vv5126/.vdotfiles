if 1 && isdirectory(expand(EverVimBundleDir("tagbar")))
    nnoremap <leader>tt :TagbarToggle<CR>
    let g:tagbar_width = 30
    let g:tagbar_sort = 0

    " let tagbar_ctags_bin=ctags
    " 设置 tagbar 子窗口的位置出现在主编辑区的左边
    let tagbar_left=1
    " 设置显示／隐藏标签列表子窗口的快捷键。
    " nnoremap <Leader>tl :TagbarToggle<CR>
    nmap tb :Tagbar<cr>
    " tagbar 子窗口中不显示冗余帮助信息
    let g:tagbar_compact=1
    " 设置 ctags 对哪些代码元素生成标签
    let g:tagbar_type_cpp = {
                \ 'kinds' : [
                \ 'd:macros:1',
                \ 'g:enums',
                \ 't:typedefs:0:0',
                \ 'e:enumerators:0:0',
                \ 'n:namespaces',
                \ 'c:classes',
                \ 's:structs',
                \ 'u:unions',
                \ 'f:functions',
                \ 'm:members:0:0',
                \ 'v:global:0:0',
                \ 'x:external:0:0',
                \ 'l:local:0:0'
                \ ],
                \ 'sro'      : '::',
                \ 'kind2scope' : {
                \ 'g' : 'enum',
                \ 'n' : 'namespace',
                \ 'c' : 'class',
                \ 's' : 'struct',
                \ 'u' : 'union'
                \ },
                \ 'scope2kind' : {
                \ 'enum'     : 'g',
                \ 'namespace' : 'n',
                \ 'class'   : 'c',
                \ 'struct' : 's',
                \ 'union'   : 'u'
                \ }
                \ }
    " Markdown Tags
    let g:tagbar_type_markdown = {
                \ 'ctagstype': 'markdown',
                \ 'ctagsbin' : '~/.vim/tools/ctags/markdown2ctags.py',
                \ 'ctagsargs' : '-f - --sort=yes',
                \ 'kinds' : [
                \ 's:sections',
                \ 'i:images'
                \ ],
                \ 'sro' : '|',
                \ 'kind2scope' : {
                \ 's' : 'section',
                \ },
                \ 'sort': 0,
                \ }

    " Rust Tags
    let g:tagbar_type_rust = {
                \ 'ctagstype' : 'rust',
                \ 'kinds' : [
                \'T:types,type definitions',
                \'f:functions,function definitions',
                \'g:enum,enumeration names',
                \'s:structure names',
                \'m:modules,module names',
                \'c:consts,static constants',
                \'t:traits,traits',
                \'i:impls,trait implementations',
                \]
                \}

    " Typescript Tags
    let g:tagbar_type_typescript = {
                \ 'ctagstype': 'typescript',
                \ 'kinds': [
                \ 'c:classes',
                \ 'n:modules',
                \ 'f:functions',
                \ 'v:variables',
                \ 'v:varlambdas',
                \ 'm:members',
                \ 'i:interfaces',
                \ 't:types',
                \ 'e:enums',
                \ 'I:imports',
                \ ]
                \ }

    " Basic R Tags
    let g:tagbar_type_r = {
                \ 'ctagstype' : 'r',
                \ 'kinds'     : [
                \ 'f:Functions',
                \ 'g:GlobalVariables',
                \ 'v:FunctionVariables',
                \ ]
                \ }

    " TXT Novel tags for English and Chinese
    let g:tagbar_type_text = {
                \ 'ctagstype': 'text',
                \ 'kinds': [
                \ 'E:EnglishChapter',
                \ 'C:ChineseChapter',
                \ ],
                \ 'sort': 0,
                \ }
endif

