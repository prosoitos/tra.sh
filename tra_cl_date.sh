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
# This script needs to be called followed by an integer
# It empties the trash up to (and including) <integer> days ago
# If <integer> is missing, all files/directories will be deleted
# except for those trashed today

topdir=$(findmnt -T . -n -o TARGET)

if [[ $topdir = /home ]]
then
    trash_path=$HOME/.local/share/Trash
else
    trash_path=$topdir/.Trash
fi

files_path=$trash_path/files
info_path=$trash_path/info

cutoff=$(date +%F -d "$1 days ago")

for i in $files_path/*(D)
do
    basename=${i#$files_path/}

    deletion_time=$(grep 'DeletionDate=' $info_path/$basename.trashinfo |
			sed 's/DeletionDate=//' |
			sed 's/T.*$//') 2> /dev/null

    # save stderr in file descriptor 3
    exec 3>&2
    # do not show stderr (prevents error when metadata is missing)
    exec 2> /dev/null

    if expr "$deletion_time" "<=" "$cutoff" >/dev/null
    then
	rm -r -f $files_path/$basename
	rm -r -f $info_path/$basename.trashinfo
    fi

    # restore stderr to prevent an exit 1
    exec 2>&3
done
