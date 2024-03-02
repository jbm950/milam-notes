import pathlib
import sys


def get_class_tag(file_path, line_num, line):
    """This function is responsible for pulling the class name from the string
    and building up the tag entry to be put in the tags file.

    Parameters
    ----------
    file_path : pathlib.Path
        This is the name of the current file relative to the overall project
        folder.
    line_num : int
        This is the line on which in the given file the class entry was found.
    line : str
        This is the string of the line in which a class entry was found.

    Returns
    -------
    str or None
        This is a tag entry formatted for a vim tags file for the found class.
        If an ignore rule was found, None will be returned instead.
    """
    class_name = line.split(" ")[1].split("(")[0].split(":")[0]
    if not class_name.startswith("Test"):
        return f"{class_name}\t{file_path}\t{line_num + 1}\n"
    return None


def get_func_tag(file_path, line_num, line):
    """This function is responsible for pulling the function/method name from
    the string and building up the tag entry to be put in the tags file.

    Parameters
    ----------
    file_path : pathlib.Path
        This is the name of the current file relative to the overall project
        folder.
    line_num : int
        This is the line on which in the given file the function/method entry
        was found.
    line : str
        This is the string of the line in which a function/method entry was
        found.

    Returns
    -------
    str or None
        This is a tag entry formatted for a vim tags file for the found
        function/method.  If an ignore rule was found, None will be returned
        instead.
    """
    IGNORE_FUNCS = ("test", "__", "teardown_method", "setup_method")
    func_name = line.lstrip().split(" ")[1].split("(")[0]
    if func_name and not func_name.startswith(IGNORE_FUNCS):
        return f"{func_name}\t{file_path}\t{line_num + 1}\n"
    return None


root = pathlib.Path(sys.argv[1])
tags = []
for dir_obj in root.rglob("*.py"):
    with open(dir_obj, "r") as py_file:
        current_file = dir_obj.relative_to(root)
        for line_num, line in enumerate(py_file.readlines()):
            if line.lstrip().startswith("class "):
                tags.append(get_class_tag(current_file, line_num, line))
            elif line.lstrip().startswith("def "):
                tags.append(get_func_tag(current_file, line_num, line))

tags = [tag for tag in tags if tag is not None]
tags = sorted(tags)
with open(root.joinpath("tags"), "w") as tags_file:
    for tag in tags:
        tags_file.write(tag)
