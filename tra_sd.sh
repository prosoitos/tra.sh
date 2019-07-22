#!/bin/zsh

topdir=$(findmnt -T . -n -o TARGET)

if [[ $topdir = /home ]]
then
    trashpath=$HOME/.local/share/Trash/
else
    trashpath=$topdir/.Trash
fi

mkdir -p $trashpath/files
mkdir -p $trashpath/info

mv $1 $trashpath/files

basename=$(echo $1 | sed -E 's/.*\/(.*)$/\1/')

echo "original_path = $1" > $trashpath/info/$basename.trashinfo
date +'%F %T' | sed 's/^/deletion_date = /' >> $trashpath/info/$basename.trashinfo
