nnoremap <space>s :set operatorfunc=<SID>GrepOperator<cr>g@
vnoremap <space>s :<c-u>call <SID>GrepOperator(visualmode())<cr>


function! s:GrepOperator(type)
    let saved_unnamed_register = @@

    if a:type ==# 'v'
        normal! `<v`>y
    elseif a:type == 'char'
        normal! `[y`]
    else
        return
    endif

    silent execute "lgrep! -R " . shellescape(@@) . " ."
    lopen
    execute "redraw!"

    let @@ = saved_unnamed_register
    let @* = saved_unnamed_register
endfunction
