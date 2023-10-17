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
# This script permanently deletes the selected files/directories from the trash
# Multiple files/directories can be selected with <tab>
# Patterns can also be used before selection of all files/directories with <ctrl-o>

# topdir=$(findmnt -T . -n -o TARGET)

# if [[ $topdir = /home ]]
# then
#     trash_path=$HOME/.local/share/Trash
# else
#     trash_path=$topdir/.Trash-1000
# fi

trash_path=$HOME/.local/share/Trash

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
done |
    sort -r |
    fzf -i -e +s -m --bind=ctrl-o:toggle-all --header "Tab: toggle, C-o: toggle-all" |
    sed -E 's/.* [D ] (.* \| .*)/\1/' |
    while read line
    do
	# select $basename from selected
	basename_selected=$(echo $line | sed -E 's/.* \| (.*)/\1/')

	# save stderr in file descriptor 3
	exec 3>&2
	# do not show stderr (prevents error when metadata is missing)
	exec 2> /dev/null

	rm -r $files_path/$basename_selected
	rm -r $info_path/$basename_selected.trashinfo

	# restore stderr to prevent an exit 1
	exec 2>&3
    done
