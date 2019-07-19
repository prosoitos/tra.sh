#!/bin/zsh

files_path=$HOME/.local/share/Trash/files
info_path=$HOME/.local/share/Trash/info

for i in $HOME/.local/share/Trash/files/*(D)
do
    if [[ -d $i ]] ; then
	dir_or_file="D"
    elif [[ -f $i ]] ; then
	dir_or_file=" "
    fi
    # remove $HOME/.local/share/Trash/files/ from f
    basename=${i#$HOME/.local/share/Trash/files/}

    original_path=$(grep 'Path=' $info_path/$basename.trashinfo | sed 's/Path=//' | sed 's/%20/ /g') 2> /dev/null
    deletion_time=$(grep 'DeletionDate=' $info_path/$basename.trashinfo | sed 's/DeletionDate=//' | sed 's/T/ /') 2> /dev/null

    list=$(echo $deletion_time $dir_or_file $original_path \| $basename)

    echo $list

done | sort -r | fzf -i -e +s
