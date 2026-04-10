vim9script

packadd lsp

call LspAddServer([{
    name: 'rust-analyzer',
    filetype: ['rust'],
    path: 'rust-analyzer',
    args: [],
}])

if filereadable(getcwd() .. '/.venv/bin/pyright-langserver')
    call LspAddServer([{
        name: 'pyright',
        filetype: ['python'],
        path: getcwd() .. '/.venv/bin/pyright-langserver',
        args: ['--stdio'],
        workspaceConfig: {
            python: {
                pythonPath: getcwd() .. '/.venv/bin/python'
            }
        }
    }])
endif

call LspOptionsSet({autoHighlightDiags: v:true})

# Key mappings
nnoremap gd :LspGotoDefinition<CR>
nnoremap gr :LspShowReferences<CR>
nnoremap K  :LspHover<CR>
nnoremap gl :LspDiag current<CR>
nnoremap <space>nd :LspDiag next \| LspDiag current<CR>
nnoremap <space>pd :LspDiag prev \| LspDiag current<CR>
