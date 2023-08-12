" Statusline Highlight Groups {{{1
highlight StatusLineNormal ctermfg=16 ctermbg=11
highlight StatusLineInsert ctermfg=16 ctermbg=40
highlight StatusLineReplace ctermfg=16 ctermbg=13
highlight StatusLineVisual ctermfg=16 ctermbg=166
highlight StatusLineCommand ctermfg=16 ctermbg=39
highlight StatusLineGitBranch ctermfg=15 ctermbg=8
highlight StatusLineInactive ctermfg=16 ctermbg=8

" Mode Settings {{{1
let s:mode_dict = {
    \ 'n' : {
        \ 'text' : 'NORMAL',
        \ 'color_group' : 'StatusLineNormal'
    \ },
    \ 'i' : {
        \ 'text' : 'INSERT',
        \ 'color_group' : 'StatusLineInsert'
    \ },
    \ 'R' : {
        \ 'text' : 'REPLACE',
        \ 'color_group' : 'StatusLineReplace'
    \ },
    \ 'v' : {
        \ 'text' : 'VISUAL',
        \ 'color_group' : 'StatusLineVisual'
    \ },
    \ 'V' : {
        \ 'text' : 'V-LINE',
        \ 'color_group' : 'StatusLineVisual'
    \ },
    \ "\<C-v>" : {
        \ 'text' : 'V-BLOCK',
        \ 'color_group' : 'StatusLineVisual'
    \ },
    \ 'c' : {
        \ 'text' : 'COMMAND',
        \ 'color_group' : 'StatusLineCommand'
    \ },
\ }

" ModeText() {{{2
function! ModeText()
    let current_mode = mode()

    if has_key(s:mode_dict, current_mode)
        return '  ' . s:mode_dict[current_mode]['text']
    endif

    return ''
endfunction

" ModeColor() {{{2
function! ModeColor()
    let current_mode = mode()

    if has_key(s:mode_dict, current_mode)
        return "%#" . s:mode_dict[current_mode]['color_group'] . "#"
    endif

    return '%#StatusLine#'
endfunction

" GetGitBranch() {{{1
function! GetGitBranch()
    let git_branch = system("git -C " . expand("%:p:h") . " rev-parse --abbrev-ref HEAD")
    if git_branch =~# "fatal"
        return ""
    else
        " Slicing cuts off trailing "^@" character
        return " " . git_branch[:-2] . " "
    endif
endfunction

" StatuslineActive() {{{1
function! StatuslineActive()
    let statusline=''
    let statusline.='%{%ModeColor()%}'
    let statusline.='%{ModeText()}'
    let statusline.=' '
    let statusline.='%#StatuslineGitBranch#%{b:git_branch}'
    let statusline.='%#StatusLine#'
    let statusline.=' %t'
    let statusline.='%h%m%r'

    let statusline.='%='
    let statusline.='%{%ModeColor()%}'
    let statusline.='[%{&filetype}]'
    let statusline.=' %l/%L,'
    let statusline.='%c'
    let statusline.='%V'
    let statusline.=' %p%%'
    return statusline
endfunction

" StatuslineInactive() {{{1
function! StatuslineInactive()
    let statusline=''
    let statusline.='%#StatuslineInactive# '
    let statusline.='%{b:git_branch}'
    let statusline.='%#StatusLineNC#'
    let statusline.=' %t'
    let statusline.='%h%m%r'

    let statusline.='%='
    let statusline.='%#StatuslineInactive#'
    let statusline.='[%{&filetype}]'
    let statusline.=' %l/%L,'
    let statusline.='%c'
    let statusline.='%V'
    let statusline.=' %p%%'
    return statusline
endfunction

" Triggers to update statusline variables {{{1
augroup StatusLineVariables
    autocmd!
    autocmd BufEnter,BufRead * let b:git_branch = GetGitBranch()
augroup END

" Set the active/inactive statuslines {{{1
augroup StatusLine
    autocmd!
    autocmd WinEnter,BufEnter * setlocal statusline=%{%StatuslineActive()%}
    autocmd WinLeave,BufLeave * setlocal statusline=%{%StatuslineInactive()%}
augroup end
