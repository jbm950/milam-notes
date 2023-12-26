import datetime
import pathlib
import sys


def new_daily_note(arg_notes_dir):
    today = datetime.date.today()
    previous_date = datetime.date.today()

    # Assuming anything more than 50 days old doesn't need to be copied into
    # current note.
    for i in range(50):
        test_file_name = previous_date.isoformat() + ".md"
        test_file_path = arg_notes_dir.joinpath(test_file_name)

        current_day_note_already_exists = test_file_path.is_file() and i == 0
        if current_day_note_already_exists:
            return
        elif test_file_path.is_file():
            previous_daily_note_path = test_file_path
            break

        previous_date = previous_date - datetime.timedelta(days=1)
    else:
        previous_daily_note_path = None

    if previous_daily_note_path is not None:
        projects_section_found = False
        projects_lines = ['# Projects\n']
        with open(previous_daily_note_path, "r") as prev_daily_note:
            for line in prev_daily_note:
                if line == "# Projects\n":
                    projects_section_found = True
                elif line.startswith("# ") and projects_section_found == True:
                    break
                elif projects_section_found:
                    projects_lines.append(line)

        prev_projects_text = "".join(projects_lines)
    else:
        prev_projects_text = "# Projects\n\n\n"

    new_daily_note_path = arg_notes_dir.joinpath(today.isoformat() + ".md")
    template = (f"# {today.isoformat()}\n\n"
                "# Day Planning\n"
                "## What would I like to accomplish today?\n\n"
                "## What could I do just a little better today?\n\n\n"
                f"{prev_projects_text}"
                "# Other Notes\n\n\n"
                "# End of Day Reflection\n"
                "## Top 3 Accomplishments\n- \n- \n- \n\n"
                "## What Went Well\n\n"
                "## What could have been better\Lessons Learned\n\n")

    with open(new_daily_note_path, "w") as new_daily_note:
        new_daily_note.write(template)


if __name__ == "__main__":
    if len(sys.argv) < 2:
        raise IndexError("Need to pass in a path to the folder to manage daily notes")
    notes_dir = pathlib.Path(sys.argv[1])
    new_daily_note(arg_notes_dir=notes_dir)
