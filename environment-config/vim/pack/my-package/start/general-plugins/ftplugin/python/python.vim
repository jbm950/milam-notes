" Mappings {{{1
nnoremap <buffer> <space>l :PylintLopen<CR>
vnoremap <buffer> <space>c :<c-u>PyToggleComment<CR>
nnoremap <space>tf :PytestFunction<CR>
nnoremap <space>tc :PytestClass<CR>
nnoremap <space>tF :PytestFile<CR>
nnoremap <space>ts :PytestSubfolder<CR>
nnoremap <space>tp :PytestProject<CR>
nnoremap <space>td :DoctestFile<CR>
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
command PylintLopen call PythonLint(expand('%:p'))
command PytestFunction call PytestFunctionFunc()
command PytestClass call PytestClassFunc()
command PytestFile !pytest -v %
command PytestSubfolder call PytestSubfolderFunc()
command PytestProject !pytest -v .
command DoctestFile !python -m doctest -v %
command DocstringParameters call InsertDocstringHeader("Parameters")
command DocstringReturns call InsertDocstringHeader("Returns")
command DocstringYields call InsertDocstringHeader("Yields")


" Functions {{{1
function! InsertDocstringHeader(header)
    let dashes = repeat("-", strlen(a:header))
    execute "normal! a" . a:header .  "\n" . dashes . "\n \<esc>"
    startinsert
endfunction

function! PythonLint(path)
    " Pylint options disabled
    " R0902 - Too many instance attributes
    " R0903 - Too few public methods
    " C0114 - Missing module docstring
    " C0115 - Missing class docstring
    " C0302 - Too many lines in module
    " Test file specific disables
    " W0201 - Attribute defined outside init
    " C0116 - Missing function/method docstring
    let pylint_disable = "R0902,R0903,C0114,C0115,C0302"
    if fnamemodify(a:path, ":t") =~# "\^test"  " disable more options for test files
        let pylint_disable = pylint_disable . ",W0201,C0116"
    endif

    let pylint_string = 'pylint "'..a:path..'" --disable='..pylint_disable..' | tail -n +2 | head -n -4'
    let pycodestyle_string = 'pycodestyle "'..a:path..'" --ignore=E501,E123,W503'
    lex system('{ { '..pylint_string..'; } && '..pycodestyle_string..'; }') | lopen
endfunction

function! PytestFunctionFunc()
    let save_pos = getpos(".")
    execute "normal [mw"
    execute "!pytest -v % -k " . expand('<cword>')
    call setpos('.', save_pos)
endfunction

function! PytestClassFunc()
    let save_pos = getpos(".")
    execute "normal [[w"
    execute "!pytest -v % -k " . expand('<cword>')
    call setpos('.', save_pos)
endfunction

function! PytestSubfolderFunc()
    execute "!pytest -v " . expand('%:h')
endfunction
