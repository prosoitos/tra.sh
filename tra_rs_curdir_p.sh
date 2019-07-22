#!/bin/zsh

files_path=$HOME/.local/share/Trash/files
info_path=$HOME/.local/share/Trash/info
dir=$(pwd)

file=$(
    for i in $HOME/.local/share/Trash/files/*(D)
    do
	if [[ -d $i ]]
	then
	    dir_or_file="D"
	else
	    dir_or_file=" "
	fi
	# remove $HOME/.local/share/Trash/files/ from f
	basename=${i#$HOME/.local/share/Trash/files/}

	# 2> /dev/null so as not to get error messages if the .trashinfo file is missing
	original_path=$(grep 'Path=' $info_path/$basename.trashinfo | sed 's/Path=//' | sed 's/%20/ /g') 2> /dev/null
	deletion_time=$(grep 'DeletionDate=' $info_path/$basename.trashinfo | sed 's/DeletionDate=//' | sed 's/T/ /') 2> /dev/null

	list=$(echo $deletion_time $dir_or_file $basename \| $original_path \| $HOME/.local/share/Trash/files/$basename )

	echo $list | grep $dir

	# remove the deletion time from the line selected by fzf
    done | sort -r | fzf -i -e +s --preview="source-highlight --failsafe -f esc256 -i {-1}"
    )

# select $basename from selection
basename_file=$(echo $file | sed -E 's/.* \| (.*)/\1/')

original_path_file=$(echo $file | sed -E 's/(.*) \| .*/\1/')

# select only the base part of $original_path (removing basename from it)
# original_basepath=$(echo $file | sed -E 's/^(.*)\/.* \| .*/\1/')
original_basepath=$(echo $original_path_file | sed -E 's/^(.*)\/.*/\1/')

# create all parents directory of the deleted files if needed
# this won't delete anything if the directories already exists
# remove 2> /dev/null to get error messages printed (to debug if the script stops working)
# 2> /dev/null allows not to have error message if the script is aborted after fzf
mkdir -p $original_basepath 2> /dev/null

# exit 1 to stop the script here if it fails so as not to loose the info file
# this will add the suffix ~conflict-with-restored-file to any file which has the same name as the restored file
# in case I recreated a new file and forgot when restoring the old file
# 2> /dev/null: same as previous line of code
mv --suffix=~conflict-with-restored-file $files_path/$basename_file $original_path_file 2> /dev/null || exit 1

# if all worked, delete info file
rm $info_path/$basename_file.trashinfo
