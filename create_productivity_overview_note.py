"""Used to create a projects or backlog note based on the contents of their
subdirectory.
"""

import pathlib
import sys


OVERVIEW_FILE_NAMES = ["_Project_Main.md", "_Backlog_Main.md"]


def write_contents_formatted(overview_file, project_folder_path, iter_level):
    """This function will populate a file with a tree like list of markdown
    files and sub directories with markdown files for a given project folder.
    Note this function acts recursively.

    Parameters
    ----------
    overview_file : file
        This is the file to write the markdown style links of a directory tree
        in.
    project_folder_path : pathlib.Path
        This is a path to walk looking for markdown files recursively
    iter_level : int
        This is the subfolder depth starting at 0 and increasing as it goes
        deeper into subfolders.
    """

    folders = []
    for path in project_folder_path.iterdir():
        if path.name in OVERVIEW_FILE_NAMES:
            continue

        if path.is_file():
            if path.suffix == ".md":
                overview_file.write("    "*iter_level + f"- [[{path.stem}]]\n")
        else:
            folders.append(path)

    for folder in folders:
        overview_file.write("\n" + "    "*iter_level + f"- {folder.stem}\n")
        write_contents_formatted(overview_file, folder, iter_level+1)


if __name__ == "__main__":
    if len(sys.argv) < 3:
        raise IndexError("Need to pass in a path to the productivity folder and the "
                         "productivity file.")
    overview_file_path = pathlib.Path(sys.argv[1])
    project_folder_path = pathlib.Path(sys.argv[2])

    with open(overview_file_path, "w") as overview_file:
        write_contents_formatted(overview_file, project_folder_path, iter_level=0)
