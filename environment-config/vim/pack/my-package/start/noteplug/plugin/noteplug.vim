" Mappings {{{1
nnoremap <leader>nd :OpenDailyNote<CR>|  " Note Daily
nnoremap <leader>nw :OpenWeeklyNote<CR>|  " Note Weekly
nnoremap <leader>nm :OpenMonthlyNote<CR>|  " Note Monthly
nnoremap <leader>na :edit $NOTES_DIR/activity-planner.md<CR>|  " Note Activity planner
nnoremap <leader>np :OpenProjectMainNote<CR>|  " Note Projects
nnoremap <leader>nb :OpenBacklogMainNote<CR>|  " Note Backlog
nnoremap <leader>nh :edit $NOTES_DIR/_Home.md<CR>|  " Note Home
nnoremap <leader>nt :!grep -rPoh --include=*.md
    \ --exclude-dir=Journal --exclude-dir=Productivity --exclude-dir=Templates
    \ "\s(\#[^\s\#]*)" .
    \ <bar> sort -u<CR>|  " Note Tags
nnoremap <leader>nnq :NewQuestionNote<CR>|  " Note New Question
nnoremap <leader>nnpg :NewGenericProjectNote<CR>|  " Note New Project Generic
nnoremap <leader>nnpt :NewTripProjectNote<CR>|  " Note New Project Trip
nnoremap <leader>nnpp :NewProgrammingProjectNote<CR>|  " Note New Project Programming
nnoremap <leader>nnsb :NewSourceBookNote<CR>|  " Note New Source Book

" Commands {{{1
command NewDailyNote silent !python "$MILAM_NOTES_REPO_DIR/new_daily_note.py" "$NOTES_DIR/Journal/Daily"
command OpenDailyNote call noteplug#OpenDailyNoteFunc()

command NewWeeklyNote silent !python "$MILAM_NOTES_REPO_DIR/new_weekly_note.py" "$NOTES_DIR/Journal/Weekly"
command OpenWeeklyNote call noteplug#OpenWeeklyNoteFunc()

command NewMonthlyNote silent !python "$MILAM_NOTES_REPO_DIR/new_monthly_note.py" "$NOTES_DIR/Journal/Monthly"
command OpenMonthlyNote call noteplug#OpenMonthlyNoteFunc()

command OpenProjectMainNote call noteplug#OpenProjectMainFunc()

command OpenBacklogMainNote call noteplug#OpenBacklogMainFunc()

command NewQuestionNote call noteplug#NoteNew("$NOTES_DIR/", "$NOTES_DIR/Templates/question-note.md")
command NewGenericProjectNote call noteplug#NoteNew("$NOTES_DIR/Projects/", "$NOTES_DIR/Templates/project-generic.md")
command NewTripProjectNote call noteplug#NoteNew("$NOTES_DIR/Projects/", "$NOTES_DIR/Templates/project-plan-trip.md")
command NewProgrammingProjectNote call noteplug#NoteNew("$NOTES_DIR/Projects/", "$NOTES_DIR/Templates/project-programming.md")
command NewSourceBookNote call noteplug#NoteNew("$NOTES_DIR/Sources/", "$NOTES_DIR/Templates/source-book.md")
