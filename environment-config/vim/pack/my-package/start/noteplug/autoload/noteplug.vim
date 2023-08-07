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
function! noteplug#OpenProjectMainFunc()
    let g:ProjectMainPath =  "$NOTES_DIR/Productivity/Projects/_Project_Main.md"
    NewProjectMainNote
    execute "redraw!"
    execute "view " . g:ProjectMainPath
    execute "setlocal nomodifiable"
endfunction

""" OpenBacklogMainFunc() {{{2
function! noteplug#OpenBacklogMainFunc()
    let g:BacklogMainPath =  "$NOTES_DIR/Productivity/Backlog/_Backlog_Main.md"
    NewBacklogMainNote
    execute "redraw!"
    execute "view " . g:BacklogMainPath
    execute "setlocal nomodifiable"
endfunction
