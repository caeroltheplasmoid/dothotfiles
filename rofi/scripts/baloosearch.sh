#!/usr/bin/zsh
FILE_OPENER="rifle" 
SEARCH_TOOL="baloosearch"

if [ -z "$@" ]
then
    echo "<Enter a query for desktop search>"
else
    if [ -f "$@" ]
    then
        $FILE_OPENER "$@"
    else
        $SEARCH_TOOL "$@" | sed \$d
    fi
fi
