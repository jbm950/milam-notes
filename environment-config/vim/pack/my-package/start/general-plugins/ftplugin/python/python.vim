" Mappings {{{1
nnoremap <buffer> <leader>pl :PylintLopen<CR>
vnoremap <buffer> <space>c :<c-u>PyToggleComment<CR>


" Syntax Highlighting {{{1
highlight BadWhitespace ctermbg=red guibg=darkred
augroup python_syntax_highlighting
    autocmd!
    autocmd BufRead,BufNewFile *.py,*.pyw, match BadWhitespace /\s\+$/
augroup END


" Commands {{{1
command PyToggleComment call toggle_comment#ToggleCommentFunc("#")
