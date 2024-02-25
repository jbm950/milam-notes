" Mappings {{{1
nnoremap <buffer> <space>l :PylintLopen<CR>
vnoremap <buffer> <space>c :<c-u>PyToggleComment<CR>
inoremap <buffer> Para a<esc>x:DocstringParameters<CR>
inoremap <buffer> Ret a<esc>x:DocstringReturns<CR>
inoremap <buffer> Yie a<esc>x:DocstringYields<CR>


" Syntax Highlighting {{{1
highlight BadWhitespace ctermbg=red guibg=darkred
augroup python_syntax_highlighting
    autocmd!
    autocmd BufRead,BufNewFile *.py,*.pyw, match BadWhitespace /\s\+$/
augroup END


" Commands {{{1
command PyToggleComment call toggle_comment#ToggleCommentFunc("#")
command PylintLopen lex system('pylint "'..expand('%:p')..'" | tail -n +2 | head -n -4') | lopen
command DocstringParameters call InsertDocstringHeader("Parameters")
command DocstringReturns call InsertDocstringHeader("Returns")
command DocstringYields call InsertDocstringHeader("Yields")


" Functions {{{1
function! InsertDocstringHeader(header)
    let dashes = repeat("-", strlen(a:header))
    execute "normal! a" . a:header .  "\n" . dashes . "\n \<esc>"
    startinsert
endfunction
