#!/bin/zsh
#
#		   /
#		   |_|  >_
#
#     https://marie-helene-burle.netlify.com
#     https://github.com/prosoitos
#     https://twitter.com/MHBurle
#     msb2@sfu.ca

# This script sends a file/directory to trash
# (creating the trash if necessary)
# and stores the metadata necessary to restore the file/directory

topdir=$(findmnt -T . -n -o TARGET)

if [[ $topdir = /home ]]
then
    trash_path=$HOME/.local/share/Trash
else
    trash_path=$topdir/.Trash
fi

mkdir -p $trash_path/files
mkdir -p $trash_path/info

basename=$(echo $1 | sed -E 's/.*\/(.*)$/\1/')

trash_file=$trash_path/files/$basename

if [[ -e $trash_file ]]
then
   i=0
   while [[ -e $trash_file_$i ]] ; do
       let i++
   done
   basename=$basename_$i
fi

mv $1 $trash_path/files/$basename

echo "[Trash Info]" > $trash_path/info/$basename.trashinfo
echo "Path=$1" >> $trash_path/info/$basename.trashinfo
date +'%FT%T' | sed 's/^/DeletionDate=/' >> $trash_path/info/$basename.trashinfo
