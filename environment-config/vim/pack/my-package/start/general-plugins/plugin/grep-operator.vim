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

    if executable('rg')
        let exclude_str = "-g !\*.pyc -g !\*.swp -g !tags"
        silent execute "lgrep! " . shellescape(@@) . " . -g !.git " . exclude_str
    else
        let exclude_str = "--exclude=\*.pyc --exclude=\*.swp --exclude=tags"
        silent execute "lgrep! -R " . shellescape(@@) . " . --exclude-dir=.git " . exclude_str
    endif
    lopen
    execute "redraw!"

    let @@ = saved_unnamed_register
    let @* = saved_unnamed_register
endfunction
