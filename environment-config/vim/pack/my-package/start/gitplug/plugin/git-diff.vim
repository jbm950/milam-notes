" Mappings {{{1
nnoremap <leader>gd :call GitDiff()<CR>

" GitDiff() {{{1
" This function is responsible for opening a diff window of the current file
" in a new tab. It tries to take into account when the terminal is in 1 vs 2
" monitors.
function GitDiff()
    let cur_width = winwidth(0)
    let cur_buffer = bufname()

    tabnew
    let full_tab_width = winwidth(0)

    " Try to account for 2 monitor setups
    if full_tab_width/cur_width > 2
        execute "vsplit " . cur_buffer
        let right_win = win_getid()
        execute "vsplit " . cur_buffer
        let left_win = win_getid()

        execute "vertical resize " . cur_width
        call win_gotoid(right_win)
        execute "vertical resize " . cur_width
    else
        let right_win = win_getid()
        execute "buf " . cur_buffer
        execute "vsplit " . cur_buffer
        let left_win = win_getid()
        call win_gotoid(right_win)
    endif
    
    let original_ft = &filetype
    enew
    let file_at_head = system("git show HEAD:" . expand("#:."))
    call append(0, split(file_at_head, '\n'))

    " Appending the output leaves an extra line at the end and the cursor at
    " the bottom of the file
    normal dd
    normal gg

    " File at HEAD window settings
    execute "set filetype=" . original_ft
    setlocal nomodifiable
    setlocal buftype=nofile
    silent execute "file __File_at_HEAD__"
    diffthis

    call win_gotoid(left_win)
    diffthis
    normal gg
endfunction
