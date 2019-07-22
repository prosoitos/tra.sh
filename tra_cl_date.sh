#!/bin/zsh
#
#		   /
#		   |_|  >_
#
#     https://marie-helene-burle.netlify.com
#     https://github.com/prosoitos
#     https://twitter.com/MHBurle
#     msb2@sfu.ca
#

# This script needs to be called followed by an integer
# It empties the trash up to (and including) <integer> days ago


files_path=$HOME/.local/share/Trash/files
info_path=$HOME/.local/share/Trash/info

cutoff=$(date +%F -d "$1 days ago")

for i in $HOME/.local/share/Trash/files/*(D)
do
    basename=${i#$HOME/.local/share/Trash/files/}

    deletion_time=$(grep 'DeletionDate=' $info_path/$basename.trashinfo | sed 's/DeletionDate=//' | sed 's/T.*$//') 2> /dev/null

    if expr $deletion_time "<=" $cutoff >/dev/null
    then
	rm -r $HOME/.local/share/Trash/files/$basename
	rm -r $HOME/.local/share/Trash/info/$basename.trashinfo
    fi
done
