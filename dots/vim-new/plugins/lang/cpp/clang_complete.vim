let g:deoplete#sources#clang#libclang_path = ""
if LINUX()
    let g:clang_library_path='/usr/lib/'
elseif OSX()
    let g:clang_library_path = '/Toolchains/XcodeDefault.xctoolchain/usr/lib/libclang.dylib'
endif
