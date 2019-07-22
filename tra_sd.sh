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

# This script sends a file/directory to trash
# (creating the trash if necessary)
# and stores the metadata necessary to restore the file/directory


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

echo "[Trash Info]" > $trashpath/info/$basename.trashinfo
echo "Path=$1" >> $trashpath/info/$basename.trashinfo
date +'%FT%T' | sed 's/^/DeletionDate=/' >> $trashpath/info/$basename.trashinfo
