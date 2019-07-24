#!/bin/zsh
#
#		   /
#		   |_|  >_
#
#
#     tra.sh: zsh scripts for trash management
#     https://marie-helene-burle.netlify.com
#     https://github.com/prosoitos
#     https://twitter.com/MHBurle
#     msb2@sfu.ca
#
#     GNU Affero General Public License
#
#
# This script sends files/directories to the trash
# It creates the trash if necessary
# and stores the metadata necessary to restore items
# If a file/directory of the same name already exists in trash,
# it creates numbered backups

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

date +'%FT%T' |
    sed 's/^/DeletionDate=/' >> $trash_path/info/$basename.trashinfo
