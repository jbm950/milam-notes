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

import file_priority_util


def reorder_files(folder_path):
    """This is the primary entrypoint for the module. It will coordinate the
    tasks required to reorder the priorities of backlog files.

    Parameters
    ----------
    folder_path : pathlib.Path
        This is the path to the folder containing prioritized markdown files to
        reorder.
    """

    files_to_reorder = file_priority_util.grab_files_to_reorder(folder_path)
    files_with_new_priorities = _determine_new_priority_numbers(files_to_reorder)
    file_priority_util.rename_files_with_new_priorities(files_with_new_priorities)


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


if __name__ == "__main__":
    if len(sys.argv) < 2:
        raise IndexError("Need to pass in a path to the folder to clean up priorities")
    sort_dir = pathlib.Path(sys.argv[1])
    reorder_files(sort_dir)
