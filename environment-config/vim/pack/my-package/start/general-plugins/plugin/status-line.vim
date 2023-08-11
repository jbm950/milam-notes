set statusline=
set statusline+=%t  " Name of file in the buffer
set statusline+=%h%m%r  " Flags (help, modified, read only

set statusline+=%=  " Break to Right Justified Items
set statusline+=[%{&filetype}]  " File Format
set statusline+=\ %l/%L,  " Line Number/Total lines in buffer
set statusline+=%c  " Column Number
set statusline+=%V  " Virtual Column Number
set statusline+=\ %p%%  " Percentage through file
