" Mappings {{{1
nnoremap <leader>gll :call GitLog("")<CR>|  " Git Log Log
nnoremap <leader>glb :call GitLog(" -- " . expand('%:p'))<CR>|  " Git Log Buffer
nnoremap <leader>gls :call GitScopes()<CR>|  " Git Log Scopes

" GitLog(additional_args) {{{1
function! GitLog(additional_args)
    let gitlog = system("git log --oneline" . a:additional_args)

    if gitlog =~# "fatal"
        echom gitlog[:-2]
        return
    endif

    if bufwinid('__Git_Log__') != -1
        call win_gotoid(bufwinid('__Git_Log__'))
    else
        split __Git_Log__
    endif

    setlocal modifiable
    normal! ggdG
    execute "normal! \<C-W>_"
    setlocal filetype=gitlog
    setlocal buftype=nofile

    call append(0, split(gitlog, '\v\n'))

    syntax region CommitHash start=/^/ end=/\s/ oneline
    highlight link CommitHash Type

    syntax region CommitType start=/build/ end=/(/me=s-1 oneline
    syntax region CommitType start=/chore/ end=/(/me=s-1 oneline
    syntax region CommitType start=/ci/ end=/(/me=s-1 oneline
    syntax region CommitType start=/docs/ end=/(/me=s-1 oneline
    syntax region CommitType start=/feat/ end=/(/me=s-1 oneline
    syntax region CommitType start=/fix/ end=/(/me=s-1 oneline
    syntax region CommitType start=/refactor/ end=/(/me=s-1 oneline
    syntax region CommitType start=/style/ end=/(/me=s-1 oneline
    syntax region CommitType start=/test/ end=/(/me=s-1 oneline
    highlight link CommitType Statement

    syntax region CommitScope start=/(/ms=e+1 end=/)/me=s-1
    highlight link CommitScope Constant

    setlocal nomodifiable
endfunction

" GitScopes() {{{1
function! GitScopes()
    let scope = input("What scope's log would you like to see: ")
    call GitLog(' -P --grep="(?<=\()' . scope . '(?=\))"')
endfunction
