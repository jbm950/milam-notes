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

" Commands {{{1
command NewDailyNote silent !python "$MILAM_NOTES_REPO_DIR/new_daily_note.py" "$NOTES_DIR/Journal/Daily"
command OpenDailyNote call noteplug#OpenDailyNoteFunc()

command NewWeeklyNote silent !python "$MILAM_NOTES_REPO_DIR/new_weekly_note.py" "$NOTES_DIR/Journal/Weekly"
command OpenWeeklyNote call noteplug#OpenWeeklyNoteFunc()

command NewMonthlyNote silent !python "$MILAM_NOTES_REPO_DIR/new_monthly_note.py" "$NOTES_DIR/Journal/Monthly"
command OpenMonthlyNote call noteplug#OpenMonthlyNoteFunc()

command OpenProjectMainNote call noteplug#OpenProjectMainFunc()

command OpenBacklogMainNote call noteplug#OpenBacklogMainFunc()

