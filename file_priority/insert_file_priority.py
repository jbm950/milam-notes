"""This module is used to insert a file into an already prioritized folder. The
remaining items will be reordered down in order to accommodate the new item.
Ex. insert File0.md into the second priority of:
        [01-file1.md, 02-file2.md, 03-file3.md]
                        |
                        v
    [01-file1.md, 02-File0, 03-file2.md, 04-file3.md]
"""

import pathlib
import sys

import file_priority_util
import reorder_file_priority


def insert_file_priority(file_to_insert_path, priority, folder_path):
    """This is the primary entrypoint for the module. It will coordinate the
    tasks required to insert a file with a new priority into an existing
    folder. It'll also then fill in any gaps in the priority numbers that have
    been produced.

    Parameters
    ----------
    file_to_insert_path : pathlib.Path
        This is the path to the file to insert with the given priority.
    priority : int
        This is the priority number of the folder to give the new file.
    folder_path : pathlib.Path
        This is the folder of existing prioritized files to insert the new file
        into.
    """

    current_folder_priorities = file_priority_util.grab_files_to_reorder(folder_path)
    if file_to_insert_path in current_folder_priorities:
        current_folder_priorities.pop(file_to_insert_path)

    files_with_new_priorities = _determine_new_priority_numbers(current_folder_priorities, priority)
    files_with_new_priorities.update({file_to_insert_path: priority})

    file_priority_util.rename_files_with_new_priorities(files_with_new_priorities)
    reorder_file_priority.reorder_files(folder_path)


def _determine_new_priority_numbers(files_to_reorder, priority):
    """This function will roll all the existing file priority numbers up to
    accommodate the new file.

    Parameters
    ----------
    files_to_reorder : dict
        This is a dictionary mapping the paths to each file with their current
        priority. {file_path: priority_number}

    Returns
    -------
    files_to_reorder : dict
        This is a dictionary mapping the paths to each file with their new
        priority. {file_path: new_priority_number}
    """

    for file_path, current_priority in files_to_reorder.items():
        if current_priority >= priority:
            files_to_reorder[file_path] += 1

    return files_to_reorder


if __name__ == "__main__":
    if len(sys.argv) < 4:
        raise IndexError("Need to pass in a path to the file to insert, the priority and the "
                         "folder to put it in")
    file_to_insert = pathlib.Path(sys.argv[1])
    priority = int(sys.argv[2])
    folder_to_insert_in = pathlib.Path(sys.argv[3])
    insert_file_priority(file_to_insert, priority, folder_to_insert_in)
