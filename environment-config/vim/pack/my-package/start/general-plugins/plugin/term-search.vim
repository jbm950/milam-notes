" OpenFile(...) {{{1
" This function is used as the call back after the interactive file select
" script has run. It will take the selection and open the corresponding file in
" the window that the cursor was in before the popup terminal was launched.
function OpenFile(...)
    let s:selected_file = getbufline(g:buf, "$")[0]
    call win_gotoid(s:current_win)
    call delete('.search_strings')
    execute "edit " . s:selected_file
    call popup_clear()
endfunction


" SearchFilesFunc() {{{1
" This function sets up the bash command and launches the popup terminal for
" user interaction to select a file to open.
function SearchFilesFunc()
    " Set up find command {{{2
    let exclude_paths = ["**/__pycache__/*", "./.git/*", "./.pytest_cache/*", "./*.egg-info/*",
                        \"./.obsidian/*", "./Productivity/*"]
    let exclude_extensions = ["*.swp", "*.swo", "*.pdf", "*.png", ".search_strings"]

    let find_command = "find . -type f"
    for path in exclude_paths
        let find_command .= ' -not -path "' . path . '"'
    endfor
    for extension in exclude_extensions
        let find_command .= ' -not -name "' . extension . '"'
    endfor
    " 2}}}

    let s:current_win = win_getid()
    let search_command = find_command . ' -print > .search_strings &&' .
        \ 'python "$MILAM_NOTES_REPO_DIR/fuzzy_finder/search_main.py"'

    let g:buf = term_start([&shell, '-ci', search_command],
                           \ #{hidden: 1, term_finish: 'close', exit_cb: 'OpenFile'})

    let popup_first_line = &lines / 2 - 25

    let window_first_col = win_screenpos(0)[1]
    let popup_first_col = window_first_col + winwidth(0)/2 - 45

    let winid = popup_create(g:buf, #{line: popup_first_line, col: popup_first_col, border: [],
                             \ borderhighlight: ["Normal"], minwidth: 90, minheight: 50})
endfunction


" Commands and mappings {{{1
command SearchFiles call SearchFilesFunc()
nnoremap <space>o :SearchFiles<CR>
