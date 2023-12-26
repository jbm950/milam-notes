import datetime
from dateutil.relativedelta import relativedelta
import pathlib
import sys


def new_monthly_note(arg_notes_dir):
    today = datetime.date.today()
    previous_month = datetime.date.today()

    # Assuming anything more than 3 months old doesn't need to be copied into
    # current note.
    for i in range(3):
        test_file_name = previous_month.strftime("%Y-%m.md")
        test_file_path = arg_notes_dir.joinpath(test_file_name)

        current_month_note_already_exists = test_file_path.is_file() and i == 0
        if current_month_note_already_exists:
            return
        elif test_file_path.is_file():
            previous_monthly_note_path = test_file_path
            break

        previous_month = today - relativedelta(months=i+1)
    else:
        previous_monthly_note_path = None

    if previous_monthly_note_path is not None:
        goals_section_found = False
        goals_lines = ['# Goals this Month\n']
        with open(previous_monthly_note_path, "r") as prev_monthly_note:
            for line in prev_monthly_note:
                if line == "# Goals this Month\n":
                    goals_section_found = True
                elif line.startswith("# ") and goals_section_found == True:
                    break
                elif goals_section_found:
                    goals_lines.append(line)

        prev_goals_text = "".join(goals_lines)
    else:
        prev_goals_text = "# Goals this Month\n\n\n"

    new_monthly_note_path = arg_notes_dir.joinpath(today.strftime("%Y-%m.md"))
    template = (f"# {today.strftime('%Y-%m %B')}\n"
                "# Month Planning\n"
                "## What could I do just a little better this month?\n\n\n"
                f"{prev_goals_text}"
                "# Broken Out By Week\n\n\n"
                "# Other Notes\n\n\n"
                "# End of Month Reflection\n"
                "## Top 3 Accomplishments\n- \n- \n- \n\n"
                "## What Went Well\n\n"
                "## What could have been better\Lessons Learned\n\n")

    with open(new_monthly_note_path, "w") as new_monthly_note:
        new_monthly_note.write(template)


if __name__ == "__main__":
    notes_dir = pathlib.Path(sys.argv[1])
    new_monthly_note(arg_notes_dir=notes_dir)
