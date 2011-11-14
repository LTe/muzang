#!/bin/sh
#
# massren: Mass file rename utility
#
if [ $# -eq 2 ]
then
    for filename in *$1*
    do
          mv -fT "$filename" `echo $filename | sed -e "s/$1/$2/"`
    done
    exit 0
else
    echo "\nUsage:"
    echo "masren textfrom textto"
    echo "\nWhere:"
    echo "textfrom is the text to replace in each file name."
    echo "textto is the new replacement text.\n"
    exit 1
fi
