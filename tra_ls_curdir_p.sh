#!/bin/zsh

files_path=$HOME/.local/share/Trash/files
info_path=$HOME/.local/share/Trash/info
dir=$(pwd)

for f in $HOME/.local/share/Trash/files/*(D)
do
    if [[ -d $f ]] ; then
	dir_or_file="D"
    elif [[ -f $f ]] ; then
	dir_or_file="|"
    fi
    # remove $HOME/.local/share/Trash/files/ from f
    basename=${f#$HOME/.local/share/Trash/files/}

    original_path=$(grep 'Path=' $info_path/$basename.trashinfo | sed 's/Path=//' | sed 's/%20/ /g') 2> /dev/null
    deletion_time=$(grep 'DeletionDate=' $info_path/$basename.trashinfo | sed 's/DeletionDate=//' | sed 's/T/ /') 2> /dev/null

    list=$(echo $deletion_time \| $basename \| $original_path \| $HOME/.local/share/Trash/files/$basename )

    # echo $list | grep $dir
    echo $list | grep $dir

    # remove the deletion time from the line selected by fzf
done | sort -r | fzf -i -e +s --preview="source-highlight --failsafe -f esc256 -i {-1}"
