" Functions {{{1
function! toggle_comment#ToggleCommentFunc(comment_char)
    let original_indent_expr = &indentexpr
    let original_autoindent = &autoindent
    setlocal indentexpr=
    setlocal noautoindent

    normal! `<
    let start = line('.')
    normal! `>
    let end = line('.')

    let min_indent = 99
    for line_num in range(start, end)
        if indent(line_num) < min_indent
            let min_indent = indent(line_num)
        endif
    endfor

    let already_commented = 1
    for line_num in range(start, end)
        if getline(line_num)[min_indent:min_indent+1]  !=# a:comment_char . " "
            let already_commented = 0
        endif
    endfor

    for line_num in range(start, end)
        call cursor(line_num, min_indent+1)
        if already_commented
            normal xx
        else
            execute "normal! i" . a:comment_char . " \<esc>"
        endif
    endfor

    let &autoindent = original_autoindent
    let &indentexpr = original_indent_expr
endfunction
