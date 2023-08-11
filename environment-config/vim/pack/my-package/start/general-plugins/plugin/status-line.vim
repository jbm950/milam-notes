" ModeText() {{{1
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

" GetGitBranch() {{{1
function! GetGitBranch()
    let git_branch = system("git -C " . expand("%:p:h") . " rev-parse --abbrev-ref HEAD")
    if git_branch =~# "fatal"
        return ""
    else
        " Slicing cuts off trailing "^@" character
        return git_branch[:-2] . " "
    endif
endfunction

" Triggers to update statusline variables {{{1
augroup StatusLineVariables
    autocmd!
    autocmd BufEnter,BufRead * let b:git_branch = GetGitBranch()
augroup END

" Set statusline {{{1
set statusline=
set statusline+=%{ModeText()}\   " Name of current vim editing mode
set statusline+=%{b:git_branch}  " Name of current git branch if inside a repository
set statusline+=%t  " Name of file in the buffer
set statusline+=%h%m%r  " Flags (help, modified, read only

set statusline+=%=  " Break to Right Justified Items
set statusline+=[%{&filetype}]  " File Format
set statusline+=\ %l/%L,  " Line Number/Total lines in buffer
set statusline+=%c  " Column Number
set statusline+=%V  " Virtual Column Number
set statusline+=\ %p%%  " Percentage through file
