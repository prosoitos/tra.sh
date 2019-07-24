#!/bin/zsh
#
#		   /
#		   |_|  >_
#
#     https://marie-helene-burle.netlify.com
#     https://github.com/prosoitos
#     https://twitter.com/MHBurle
#     msb2@sfu.ca

# This script empties the trash

topdir=$(findmnt -T . -n -o TARGET)

if [[ $topdir = /home ]]
then
    trash_path=$HOME/.local/share/Trash
else
    trash_path=$topdir/.Trash
fi

# save stderr in file descriptor 3
exec 3>&2
# do not show stderr (prevents 'no matches found' err to be displayed when the trash is empty)
exec 2> /dev/null

# -f flag to delete files/dirs regardless of permission
rm -r -f $trash_path/files/*(D)
rm -r -f $trash_path/info/*(D)

# restore stderr to prevent an exit 1
exec 2>&3
