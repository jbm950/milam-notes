#!/bin/sh

# Based on: https://github.com/Emceelamb/shell-bookmarks/tree/master

bookmarkfile="$HOME/.shellbookmarks"

if [ ! -e "$bookmarkfile" ]
then
    touch $bookmarkfile
    echo -e "Bookmark location: $bookmarkfile"
fi

bmk() {
    saved_bookmarks=()
    while IFS= read -r line; do
        saved_bookmarks+=("$line")
    done < $bookmarkfile

    # Display help menu
    if [[ -z "$1" ]] || [[ $1 == '-h' ]]; then
        echo "This utility will be responsible for handling bookmarks for easy"
        echo "directory jumping in a bash terminal."
        echo
        echo "Syntax: bmk [g|s|l|d|clear]"
        echo "options:"
        echo "    g #       Go to bookmark location corresponding to #."
        echo "    s         Save current directory as a bookmark."
        echo "    l         List bookmarked directories."
        echo "    d #       Delete bookmark location corresponding to #."
        echo "    clear     Delete all bookmarks"

    # Go to bookmark
    elif [[ $1 == 'g' ]]; then
        bookmark=( ${saved_bookmarks[$2]} )
        cd ${bookmark[0]}
        echo -e "Go to ${bookmark[1]}."

    # Save current directory as bookmark
    elif [[ $1 == 's' ]]; then
        current_dir=$(pwd)
        basename=$(basename $current_dir)
        echo $current_dir $basename >> $bookmarkfile
        echo -e "Saved $basename to bookmarks."

    # List full paths of bookmarks
    elif [[ $1 == 'l' ]] && [[ $2 == '-v' ]]; then
        counter=0
        for i in "${saved_bookmarks[@]}"
        do
            bookmark=($i)
            printf '[%d] %s\n' "$counter" "${bookmark[0]}"
            (( counter++ ))
        done

    # List bookmark folder names
    elif [[ $1 == 'l' ]]; then
        counter=0
        for i in "${saved_bookmarks[@]}"
        do
            bookmark=($i)
            printf '[%d] /%s\n' "$counter" "${bookmark[1]}"
            (( counter++ ))
        done

    # Delete bookmark
    elif [[ $1 == 'd' ]]; then
        bookmark=( ${saved_bookmarks[$2]} )
        to_delete=$(($2 + 1))
        sed -i "${to_delete}d" $bookmarkfile
        echo -e "Deleted ${bookmark[1]} from bookmarks."

    # Delete all bookmarks
    elif [[ $1 == 'clear' ]]; then
        mv $bookmarkfile ${bookmarkfile}.bak
        touch $bookmarkfile
        echo "Cleared all bookmarks."
    fi
}
