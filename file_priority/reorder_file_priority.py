"""This module is used to reorder priority of backlog items in the note system.
In the notes, backlog items may be prioritized for importance by appending a
number to the beginning of the file name. Currently the number is 2 digits and
is padded with a zero when less than 10. While working through the backlog,
items will get pulled and the remaining items will need their numbers updated.
This script will automate that task, renumbering the priority items to make
them contiguous from 1 to n for n markdown files in the folder.

(ex 02_item2.md, 04_item4.md -> 01_item2.md, 02_item4.md)

Note: This module will not change the prioritization of files in relation to
each other. It will just fill in any gaps in the numbers that have appeared.

Note: Priority 99 is used as a default for lowest priority and so those files
are not updated.
"""

import pathlib
import sys


def reorder_files(folder_path):
    """This is the primary entrypoint for the module. It will coordinate the
    tasks required to reorder the priorities of backlog files.

    Parameters
    ----------
    folder_path : pathlib.Path
        This is the path to the folder containing prioritized markdown files to
        reorder.
    """

    files_to_reorder = _grab_files_to_reorder(folder_path)
    files_with_new_priorities = _determine_new_priority_numbers(files_to_reorder)
    _rename_files_with_new_priorities(files_with_new_priorities)


def _grab_files_to_reorder(folder_path):
    """This function is responsible for building up a dictionary of all of the
    files to reprioritize in the folder and determining what their current
    priority is.

    Parameters
    ----------
    folder_path : pathlib.Path
        This is the path to the folder containing prioritized markdown files to
        reorder.

    Returns
    -------
    result : dict
        This is a dictionary mapping the paths to each file with their current
        priority. {file_path: priority_number}
    """

    result = {}
    for dir_obj in folder_path.iterdir():
        file_first_two_char = dir_obj.name[0:2]

        # I use 99 as default lowest priority and so those files don't need to
        # be renumbered
        skip_99 = file_first_two_char != "99"
        is_markdown_file = dir_obj.suffix == ".md"
        if is_markdown_file and file_first_two_char.isdigit() and skip_99:
            priority_num = int(file_first_two_char)
            result[dir_obj] = priority_num

    return result


def _determine_new_priority_numbers(files_to_reorder):
    """This function is responsible for determining what the new priority
    should be for each file so that they're contiguous number from 1 to n where
    n is the number of prioritized files. Note it does not change the priority
    relative to the other files, It just fills in any gaps that have appeared.

    Parameters
    ----------
    files_to_reorder : dict
        This is a dictionary mapping the paths to each file with their current
        priority. {file_path: current_priority_number}

    Returns
    -------
    files_to_reorder : dict
        This is a dictionary mapping the paths to each file with their new
        priority. {file_path: new_priority_number}
    """

    new_priority_numbers = range(1, len(files_to_reorder)+1)  # start with 1 instead of 0
    for new_priority_number in new_priority_numbers:
        current_priority_numbers = files_to_reorder.values()
        if new_priority_number not in current_priority_numbers:
            delta = None
            for file, priority_num in files_to_reorder.items():
                if delta is None and priority_num > new_priority_number:
                    delta = priority_num - new_priority_number
                if delta is not None:
                    files_to_reorder[file] -= delta

    return files_to_reorder


def _rename_files_with_new_priorities(files_to_reorder):
    """This function is responsible for the actual renaming of the files on the
    hard drive given the new priority numbers.

    Parameters
    ----------
    files_to_reorder : dict
        This is a dictionary mapping the paths to each file with their new
        priority. {file_path: new_priority_number}
    """

    for file, priority_num in files_to_reorder.items():
        priority_padded_to_2_digits = f"{priority_num:02}"
        file_name_without_original_priority = f"{file.name[2:]}"
        root_folder_path = f"{file.parent}"
        new_file_path = (f"{root_folder_path}/"
                         f"{priority_padded_to_2_digits}{file_name_without_original_priority}")
        file.rename(new_file_path)


if __name__ == "__main__":
    if len(sys.argv) < 2:
        raise IndexError("Need to pass in a path to the folder to clean up priorities")
    sort_dir = pathlib.Path(sys.argv[1])
    reorder_files(sort_dir)
