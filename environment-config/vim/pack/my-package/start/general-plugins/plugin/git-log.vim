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

    syntax region CommitField start=/Author/ end=/:/me=s-1 oneline
    syntax region CommitField start=/Date/ end=/:/me=s-1 oneline
    highlight link CommitField Type

    nnoremap <buffer> <space> :call GitToggleCommitMessage()<CR>

    setlocal nomodifiable
    normal gg
endfunction


" GitScopes() {{{1
function! GitScopes()
    let scope = input("What scope's log would you like to see: ")
    call GitLog(' -P --grep="(?<=\()' . scope . '(?=\))"')
endfunction

" GitToggleCommitMessage() {{{1
function! GitToggleCommitMessage()
    setlocal modifiable
    let cur_line_num = line('.')
    let cur_line = getline('.')

    let commit_already_open = 0
    if cur_line[:3] ==# "    "
        let commit_already_open = 1
    elseif getline(cur_line_num+1)[:3] ==# "    "
        let commit_already_open = 1
        let cur_line_num += 1
        normal j
    endif

    if !commit_already_open
        let commit_hash = split(cur_line)[0]

        let commit_format = '--pretty=format:"Author: %an%nDate: %as%n%n%b" '
        let commit_msg = system('git show -s ' . commit_format . commit_hash)
        let commit_msg_list = split(commit_msg, '\v\n')
        for msg_line_num in range(len(commit_msg_list))
            let commit_msg_list[msg_line_num] = "    " . commit_msg_list[msg_line_num]
            let commit_msg_list[msg_line_num] = substitute(commit_msg_list[msg_line_num], '', '', 'g')
        endfor

        call append(cur_line_num, commit_msg_list)
    else
        let start_line = cur_line_num
        while start_line > 0
            if getline(start_line)[:3] !=# "    "
                break
            else
                let start_line -= 1
            endif
        endwhile
        let start_line += 1

        let end_line = cur_line_num
        let numlines = line('$')
        while end_line <= numlines
            if getline(end_line)[:3] !=# "    "
                break
            else
                let end_line += 1
            endif
        endwhile
        let end_line -= 1

        call deletebufline(bufname('__Git_Log__'), start_line, end_line)
        normal k
    endif

    setlocal nomodifiable
endfunction
