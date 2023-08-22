"""This module will hold helper functions for all of the file/task priority
handling in my notes directory.
"""


def grab_files_to_reorder(folder_path):
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


def rename_files_with_new_priorities(files_to_reorder):
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
