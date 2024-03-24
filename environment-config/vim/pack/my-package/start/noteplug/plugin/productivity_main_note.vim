augroup project_main_note
    autocmd!
    autocmd BufRead,BufNewFile _Project_Main.md,_Backlog_main.md setlocal nomodifiable
    autocmd BufRead,BufNewFile _Project_Main.md,_Backlog_main.md nnoremap <buffer> m :ProductivityFileMoveTop<CR>
augroup END

command ProductivityFileMoveTop call productivity_file_move#ProductivityFileMoveTopFunc()
