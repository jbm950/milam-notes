" Mappings {{{1
vnoremap <buffer> <space>c :<c-u>VimToggleComment<CR>

" Commands {{{1
command VimToggleComment call toggle_comment#ToggleCommentFunc('"')
