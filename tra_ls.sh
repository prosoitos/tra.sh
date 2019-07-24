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
# This script lists the content of the trash

topdir=$(findmnt -T . -n -o TARGET)

if [[ $topdir = /home ]]
then
    trash_path=$HOME/.local/share/Trash
else
    trash_path=$topdir/.Trash
fi

files_path=$trash_path/files
info_path=$trash_path/info

for i in $files_path/*(D)
do
    if [[ -d $i ]]
    then
	dir_or_file="D"
    else
	dir_or_file=" "
    fi

    basename=${i#$files_path/}

    original_path=$(grep 'Path=' $info_path/$basename.trashinfo |
			sed 's/Path=//' |
			sed 's/%20/ /g') 2> /dev/null

    deletion_time=$(grep 'DeletionDate=' $info_path/$basename.trashinfo |
			sed 's/DeletionDate=//' |
			sed 's/T/ /') 2> /dev/null

    list=$(echo $deletion_time $dir_or_file $original_path \| $basename)

    echo $list
done | sort -r | fzf -i -e +s
