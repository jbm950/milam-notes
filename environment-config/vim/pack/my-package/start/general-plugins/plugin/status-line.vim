function! ModeText()
    let current_mode = mode()
    if current_mode =~# "n"
        return "NORMAL"
    elseif current_mode =~# ""
        return "V-BLOCK"
    elseif current_mode =~# "v"
        return "VISUAL"
    elseif current_mode =~# "V"
        return "V-LINE"
    elseif current_mode =~# "c"
        return "COMMAND"
    elseif current_mode =~# "i"
        return "INSERT"
    elseif current_mode =~# "R"
        return "REPLACE"
    endif
    return current_mode
endfunction

set statusline=
set statusline+=%{ModeText()}  " Name of current vim editing mode
set statusline+=\ %t  " Name of file in the buffer
set statusline+=%h%m%r  " Flags (help, modified, read only

set statusline+=%=  " Break to Right Justified Items
set statusline+=[%{&filetype}]  " File Format
set statusline+=\ %l/%L,  " Line Number/Total lines in buffer
set statusline+=%c  " Column Number
set statusline+=%V  " Virtual Column Number
set statusline+=\ %p%%  " Percentage through file
