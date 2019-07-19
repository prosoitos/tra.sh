#!/bin/zsh

files_path=$HOME/.local/share/Trash/files
info_path=$HOME/.local/share/Trash/info

for f in $HOME/.local/share/Trash/files/*(D)
do
    # remove $HOME/.local/share/Trash/files/ from f
    basename=${f#$HOME/.local/share/Trash/files/}

    original_path=$(grep 'Path=' $info_path/$basename.trashinfo | sed 's/Path=//' | sed 's/%20/ /g') 2> /dev/null
    deletion_time=$(grep 'DeletionDate=' $info_path/$basename.trashinfo | sed 's/DeletionDate=//' | sed 's/T/ /') 2> /dev/null

    list=$(echo $deletion_time \| $original_path \| $basename)

    echo $list

done | sort -r | fzf -i -e +s
