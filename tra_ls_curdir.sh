#!/bin/zsh

# set -e

files_path=/home/marie/.local/share/Trash/files
info_path=/home/marie/.local/share/Trash/info
dir=$(pwd)

file=$(
    for f in /home/marie/.local/share/Trash/files/*(D)
    do
	# remove /home/marie/.local/share/Trash/files/ from f
	basename=${f#/home/marie/.local/share/Trash/files/}

	original_path=$(grep 'Path=' $info_path/$basename.trashinfo | sed 's/Path=//' | sed 's/%20/ /g') 2> /dev/null
	deletion_time=$(grep 'DeletionDate=' $info_path/$basename.trashinfo | sed 's/DeletionDate=//' | sed 's/T/ /') 2> /dev/null

	list=$(echo $deletion_time \| $original_path \| $basename)

	# echo $list | grep $dir
	echo $list | grep $dir

	# remove the deletion time from the line selected by fzf
    done | sort -r | fzf -i -e +s
    )
