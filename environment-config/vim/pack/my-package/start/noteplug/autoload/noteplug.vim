" Functions {{{1
""" OpenDailyNoteFunc() {{{2
function! noteplug#OpenDailyNoteFunc()
    let g:DailyNotePath = "$NOTES_DIR/Journal/Daily/" . strftime("%Y-%m-%d") . ".md"
    if filereadable(g:DailyNotePath)
        ""
    else
        NewDailyNote
        execute "redraw!"
    endif
    execute "edit " . g:DailyNotePath
endfunction

""" OpenWeeklyNoteFunc() {{{2
function! noteplug#OpenWeeklyNoteFunc()
    let g:WeeklyNotePath = "$NOTES_DIR/Journal/Weekly/" . strftime("%Y-W%V") . ".md"
    if filereadable(g:WeeklyNotePath)
        ""
    else
        NewWeeklyNote
        execute "redraw!"
    endif
    execute "edit " . g:WeeklyNotePath
endfunction

""" OpenMonthlyNoteFunc() {{{2
function! noteplug#OpenMonthlyNoteFunc()
    let g:MonthlyNotePath = "$NOTES_DIR/Journal/Monthly/" . strftime("%Y-%m") . ".md"
    if filereadable(g:MonthlyNotePath)
        ""
    else
        NewMonthlyNote
        execute "redraw!"
    endif
    execute "edit " . g:MonthlyNotePath
endfunction

""" OpenProjectMainFunc() {{{2
command NewProjectMainNote silent !python "$MILAM_NOTES_REPO_DIR/create_productivity_overview_note.py"
    \ "$NOTES_DIR/Productivity/Projects/_Project_Main.md"
    \ "$NOTES_DIR/Productivity/Projects"

function! noteplug#OpenProjectMainFunc()
    let g:ProjectMainPath =  "$NOTES_DIR/Productivity/Projects/_Project_Main.md"
    NewProjectMainNote
    execute "redraw!"
    execute "view " . g:ProjectMainPath
endfunction

""" OpenBacklogMainFunc() {{{2
command NewBacklogMainNote silent !python "$MILAM_NOTES_REPO_DIR/create_productivity_overview_note.py"
    \ "$NOTES_DIR/Productivity/Backlog/_Backlog_Main.md"
    \ "$NOTES_DIR/Productivity/Backlog"

function! noteplug#OpenBacklogMainFunc()
    let g:BacklogMainPath =  "$NOTES_DIR/Productivity/Backlog/_Backlog_Main.md"
    NewBacklogMainNote
    execute "redraw!"
    execute "view " . g:BacklogMainPath
endfunction

""" NewNote(root, template) {{{2
function! noteplug#NoteNew(root, template)
    let file_name = input("Provide a name for the new file: ")

    execute "edit " . a:root . file_name
    execute "read " . a:template
    normal ggdd
endfunction
