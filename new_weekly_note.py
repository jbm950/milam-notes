import datetime
import pathlib
import sys


def new_weekly_note(arg_notes_dir):
    today = datetime.date.today()
    previous_week = datetime.date.today()

    # Assuming anything more than 6 weeks old doesn't need to be copied into
    # current note.
    for i in range(6):
        test_file_name = previous_week.strftime("%Y-W%V.md")
        test_file_path = arg_notes_dir.joinpath(test_file_name)

        current_week_note_already_exists = test_file_path.is_file() and i == 0
        if current_week_note_already_exists:
            return
        elif test_file_path.is_file():
            previous_weekly_note_path = test_file_path
            break

        previous_week = previous_week - datetime.timedelta(weeks=1)
    else:
        previous_weekly_note_path = None

    if previous_weekly_note_path is not None:
        goals_section_found = False
        goals_lines = ['# Goals this Week\n']
        with open(previous_weekly_note_path, "r") as prev_weekly_note:
            for line in prev_weekly_note:
                if line == "# Goals this Week\n":
                    goals_section_found = True
                elif line.startswith("# ") and goals_section_found == True:
                    break
                elif goals_section_found:
                    goals_lines.append(line)

        prev_goals_text = "".join(goals_lines)
    else:
        prev_goals_text = "# Goals this Week\n\n\n"

    current_week_monday = today - datetime.timedelta(days=today.weekday())
    current_week_sunday = current_week_monday + datetime.timedelta(days=6)

    current_week_monday_month = current_week_monday.strftime('%Y-%m')
    current_week_sunday_month = current_week_sunday.strftime('%Y-%m')

    month_note_link = f"[[{current_week_monday_month}]]"
    if current_week_monday_month != current_week_sunday_month:
        month_note_link += f"|[[{current_week_sunday_month}]]"

    new_weekly_note_path = arg_notes_dir.joinpath(today.strftime("%Y-W%V.md"))
    template = (f"# {today.strftime('%Y-W%V')}\n"
                f"Month Note: {month_note_link}\n\n"
                "# Week Planning\n"
                "## What could I do just a little better this week?\n\n\n"
                f"{prev_goals_text}"
                "# Other Notes\n\n\n"
                "# End of Week Reflection\n"
                "## Top 3 Accomplishments\n- \n- \n- \n\n"
                "## What Went Well\n\n"
                "## What could have been better\Lessons Learned\n\n")

    with open(new_weekly_note_path, "w") as new_weekly_note:
        new_weekly_note.write(template)


if __name__ == "__main__":
    notes_dir = pathlib.Path(sys.argv[1])
    new_weekly_note(arg_notes_dir=notes_dir)
