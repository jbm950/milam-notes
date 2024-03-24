" Productivity File Move
" This module holds the code for the file move dialog of the productivity main
" notes. It'll iterate through folders in the productivity directory of
" $NOTES_DIR until a new location for the file has been selected.
"
" Script Attributes:
" subfolder_names : list
"   This is a list of the different subfolders for the selected folder.
" file_name : string
"   This is the name of the file being moved
" productivity_folder : string/path
"   This is a reference to the productivity folder in the notes directory
" selected_folder : string/path
"   This is the folder that the dialog is currently deciding to use for the
"   new file location
" original_path : string/path
"   This is the path to the original spot the file is located so that the
"   code knows where to move it from after the final destination is decided.

let s:subfolder_names = []
let s:file_name = ''
let s:productivity_folder = '$NOTES_DIR/Productivity'
let s:selected_folder = ''
let s:original_path = ''

let s:refresh_commands = {'_Backlog_Main.md': 'noteplug#OpenBacklogMainFunc()',
                        \ '_Project_Main.md': 'noteplug#OpenProjectMainFunc()'}

" productivity_file_move#ProductivityFileMoveTopFunc() {{{1
function productivity_file_move#ProductivityFileMoveTopFunc()
    let current_line = getline('.')
    let s:file_name = matchstr(current_line, '\[\[\zs.*\ze\]\]')
    if s:file_name == ""
        echohl ErrorMsg
        echom "No file found in current line"
        echohl None
        return
    endif

    let s:file_name .= ".md"
    let s:original_path = system('find ' . expand('%:p:h') . ' -name "' . s:file_name . '"')[:-2]

    let s:subfolder_names = s:GetSubfolders(s:productivity_folder)

    call s:MovePopup('s:ProductivityFileMoveTopCB')
endfunction

" ProductivityFileMoveTopCB(id, result) {{{1
function s:ProductivityFileMoveTopCB(id, result)
    if a:result == -1
        return
    endif

    let result = a:result - 1
    let s:selected_folder = s:productivity_folder . '/' . s:subfolder_names[result]
    call s:ProductivityFileMoveSelectFolder(s:selected_folder)
endfunction

" ProductivityFileMoveSelectFolder(path) {{{1
function s:ProductivityFileMoveSelectFolder(path)
    let s:subfolder_names = s:GetSubfolders(a:path)
    call insert(s:subfolder_names, '- New Folder')
    call insert(s:subfolder_names, '- This Directory')

    call s:MovePopup('s:ProductivitySubfolderCB')
endfunction

" ProductivitySubfolderCB(id, result) {{{1
function s:ProductivitySubfolderCB(id, result)
    if a:result == -1
        return
    endif
    if a:result > 2  " Another subfolder was selected
        let s:selected_folder = s:selected_folder . '/' . s:subfolder_names[a:result - 1]
        call s:ProductivityFileMoveSelectFolder(s:selected_folder)
    elseif a:result == 1  " The current folder was selected
        call system('mv ' . s:original_path . ' ' . s:selected_folder . '/' . s:file_name)
        execute 'call ' . s:refresh_commands[expand('%:t')]
    elseif a:result == 2  " Create new subfolder was selected
        echohl ErrorMsg
        echom 'New folder creation not yet implemented'
        echohl None
    endif
endfunction

" GetSubfolders(search_path) {{{1
function s:GetSubfolders(search_path)
    let subfolders_str = system('find ' . a:search_path . ' -type d -maxdepth 1 -mindepth 1')
    let subfolders_full_paths = split(subfolders_str, '\n')
    let subfolder_names = []
    for path in subfolders_full_paths
        call add(subfolder_names, fnamemodify(path, ':t'))
    endfor
    
    return subfolder_names
endfunction

" GetPopupPos() {{{1
function s:GetPopupPos()
    let popup_height = 7
    let window_first_row = win_screenpos(0)[0]
    let popup_first_row = window_first_row + winheight(0)/2 - popup_height/2

    let popup_width = 15 + len(s:file_name)
    let window_first_col = win_screenpos(0)[1]
    let popup_first_col = window_first_col + winwidth(0)/2 - popup_width/2
    
    return [popup_first_row, popup_first_col]
endfunction

" MovePopup(call_back) {{{1
function s:MovePopup(call_back)
    let [popup_first_row, popup_first_col] = s:GetPopupPos()

    call popup_menu(s:subfolder_names, #{title: ' Move File: ' . s:file_name . ' ',
                                       \ callback: a:call_back,
                                       \ line: popup_first_row,
	                                   \ col: popup_first_col,
                                       \ pos: "topleft",
	                                   \ border: [],
	                                   \ padding: [0,1,0,1],
	                                   \ })
endfunction
