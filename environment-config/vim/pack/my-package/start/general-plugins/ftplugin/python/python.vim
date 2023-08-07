" Mappings {{{1
nnoremap <leader>pl :PylintLopen<CR>

" Syntax Highlighting {{{1
highlight BadWhitespace ctermbg=red guibg=darkred
augroup python_syntax_highlighting
    autocmd!
    autocmd BufRead,BufNewFile *.py,*.pyw, match BadWhitespace /\s\+$/
augroup END
