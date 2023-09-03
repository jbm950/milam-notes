"""This module is used to perform an interactive search where it will display
matching results for the user to select from while the user types. It pulls the
list of options to select from a file in the current working directory named
".search_strings". When complete, the module will clear the string with just
the selected option and then exit.
"""

import msvcrt
import os
import sys
import time
import colorama

# Allows coloring terminal output in git bash
colorama.init()

BACKSPACE = '\x08'
ENTER = '\r'
CTRL_P = '\x10'
CTRL_N = '\x0e'
ESC = '\x1b'
TAB = '\t'


def load_strings():
    """This function will load the list of options for the user to select from,
    from a file named ".search_strings". The file will be parsed such that each
    line in the file corresponds to an option for the user.

    Returns
    -------
    list of str
        This is a list of the options for the user to select from, pulled from
        the file ".string_search".
    """

    SEARCH_STRINGS_FILENAME = ".search_strings"
    with open(SEARCH_STRINGS_FILENAME, "r") as file:
        strings = file.read()
    return strings.split('\n')[:-1]


def contains_filter(test_string, string_list):
    """This is a simple filter that will take in a test string and a list of
    strings to filter and return the subset of the list where the strings
    contain the test string.

    Parameters
    ----------
    test_string : str
        This is the test string to compare against the strings in the list.
    string_list : list of str
        This is the list of strings to filter using the test string

    Returns
    -------
    list of str
        This is the list of strings that has been filtered by the test string.
    """

    return [item for item in string_list if test_string in item]


def update_console(display_string, selection, string_list):
    """This function is responsible for clearing the current stdout and writing
    the current state of the search (current test string and matches from the
    string list). Also it highlights the current selection from the string
    list.

    Parameters
    ----------
    display_string : str
        This is the test string that has been typed in by the user.
    selection : int
        This is a marker for which item in the string_list is currently
        selected by the user (by index of the list).
    string_list : list of str
        This is the list of remaining string options for the user to select
        between.
    """

    string_display_list = string_list.copy()
    if selection is not None and string_display_list:
        string_display_list[selection] = (f"{colorama.Back.CYAN}"
                                          f"{colorama.Fore.BLACK}"
                                          f"{string_display_list[selection]}"
                                          f"{colorama.Style.RESET_ALL}")

    os.system('cls')
    sys.stdout.write(display_string + '\n')
    sys.stdout.write("\n".join(string_display_list[:40]))
    sys.stdout.flush()


def print_final_selection(selection):
    """This function will clear the screen and then print the input string.
    Note there's a time delay included because vim closes the terminal too
    quickly and doesn't grab the last update for the selection otherwise.

    Parameters
    ----------
    selection : str
        This is the string to print to the terminal after clearing it.
    """

    update_console(selection, selection=None, string_list=[])
    time.sleep(0.15)


def main_loop(selected_filter, all_strings):
    """This function acts as the event handler while interacting with the user.
    It will take care of key presses and orchestrating the list filtering and
    screen updating as well as keeping track of the user's selection.

    Parameters
    ----------
    selected_filter : func
        This is the filter function to determine what "matches" the user's
        input.
    all_strings : list of str
        This is the list of strings to filter from as the user types

    Returns
    -------
    str
        This is the string that the user selected through the interactive
        session.
    """

    update_console("", selection=0, string_list=all_strings)

    done = False
    search_string = []
    selection = 0
    string_list = all_strings.copy()

    while not done:
        if msvcrt.kbhit():
            char = msvcrt.getwch()
            if char == BACKSPACE:
                search_string = search_string[:-1]
            elif char == CTRL_P:
                selection -= 1
                selection = max(selection, 0)
            elif char == CTRL_N:
                selection += 1
                if selection == len(string_list):
                    selection = len(string_list) - 1
            elif char == TAB:
                selection += 1
                if selection == len(string_list):
                    selection = 0
            elif char == ENTER:
                done = True
                return string_list[selection]
            elif char == ESC:
                return ESC
            else:
                search_string.append(char)
                selection = 0

            display_string = "".join(search_string)
            string_list = selected_filter(display_string, all_strings)

            update_console(display_string, selection, string_list)


if __name__ == "__main__":
    selected_filter = contains_filter
    all_strings = load_strings()

    selection = main_loop(selected_filter, all_strings)

    print_final_selection(selection)
