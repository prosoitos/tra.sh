#!/bin/zsh
#
#		   /
#		   |_|  >_
#
#     https://marie-helene-burle.netlify.com
#     https://github.com/prosoitos
#     https://twitter.com/MHBurle
#     msb2@sfu.ca

# This script restores a file/directory, with preview

topdir=$(findmnt -T . -n -o TARGET)

if [[ $topdir = /home ]]
then
    trash_path=$HOME/.local/share/Trash
else
    trash_path=$topdir/.Trash
fi

files_path=$trash_path/files
info_path=$trash_path/info

# *(D) instead of * to also include the dot files
for i in $files_path/*(D)
do
    if [[ -d $i ]]
    then
	dir_or_file="D"
    else
	dir_or_file=" "
    fi
    # remove $HOME/.local/share/Trash/files/ from f
    basename=${i#$files_path/}

    # 2> /dev/null so as not to get error messages if the .trashinfo file is missing
    original_path=$(grep 'Path=' $info_path/$basename.trashinfo | sed 's/Path=//' | sed 's/%20/ /g') 2> /dev/null
    deletion_time=$(grep 'DeletionDate=' $info_path/$basename.trashinfo | sed 's/DeletionDate=//' | sed 's/T/ /') 2> /dev/null

    list=$(echo $deletion_time $dir_or_file $basename \| $original_path \| $files_path/$basename )

    echo $list

    # remove the deletion time from the line selected by fzf
done | sort -r | fzf -i -e +s -m --bind=ctrl-o:toggle-all --preview="source-highlight --failsafe -f esc256 -i {-1}" |

    while read line

    do
	# select $basename from selected
	basename_selected=$(echo $line | sed -E 's/.* [D ] (.*) \| .* \| .*/\1/')

	original_path_selected=$(echo $line | sed -E 's/.* \| (.*) \| .*/\1/')

	# select only the base part of $original_path (removing basename from it)
	original_basepath_selected=$(echo $original_path_selected | sed -E 's/^(.*)\/.*/\1/')

	# create all parents directory of the deleted files if needed
	# this won't delete anything if the directories already exists
	# remove 2> /dev/null to get error messages printed (to debug if the script stops working)
	# 2> /dev/null allows not to have error message if the script is aborted after fzf
	mkdir -p $original_basepath_selected 2> /dev/null

	# exit 1 to stop the script here if it fails so as not to loose the info file
	# this will add the suffix ~conflict-with-restored-file to any file which has the same name as the restored file
	# in case I recreated a new file and forgot when restoring the old file
	# 2> /dev/null: same as previous line of code
	mv --suffix=~conflict-with-restored-file $files_path/$basename_selected $original_path_selected 2> /dev/null || exit 1

	# if all worked, delete info file
	rm $info_path/$basename_selected.trashinfo
    done
