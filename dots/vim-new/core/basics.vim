" Basics
set nocompatible        " Must be first line
if !WINDOWS()
    set shell=/bin/bash
    if ANDROID()
        set shell=/system/bin/sh
    endif
endif
