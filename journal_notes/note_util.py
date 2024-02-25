def find_section_in_file(file_lines, header_level, section_title):
    """This function will find a given markdown section in a given markdown
    file and return the text from the section. If the section was not found,
    it'll just return the section header.

    Parameters
    ----------
    file_lines : list of str
        This is a list where each item is a string of a line in the markdown
        file being searched.
    header_level : int
        This is the integer number corresponding to the header level
        (ie. H1 -> 1, H3 -> 3).
    section_title : str
        This is the text to the right of the header marking that is being
        searched for.

    Returns
    -------
    section_text : str
        This is a string of the text for the searched section. If the section
        was not found, the section header is all that is returned.
    """

    search_tag = "#" * header_level + f" {section_title}\n"
    section_found = False
    section_lines = [search_tag]
    for line in file_lines:
        if line == search_tag:
            section_found = True
        elif line.startswith("#" * header_level + " ") and section_found is True:
            break
        elif line == "":  # End of file found
            break
        elif section_found:
            section_lines.append(line)
    else:
        section_lines.append("\n\n")

    section_text = "".join(section_lines)

    return section_text
