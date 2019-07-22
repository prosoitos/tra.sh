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

# This script empties the trash


# save stderr in file descriptor 3
exec 3>&2
# do not show stderr (prevents 'no matches found' err to be displayed when the trash is empty)
exec 2> /dev/null

rm -r $HOME/.local/share/Trash/files/*(D)
rm -r $HOME/.local/share/Trash/info/*(D)

# restore stderr to prevent an exit 1
exec 2>&3
