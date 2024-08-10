#!/bin/sh

dotfiles_root=$(cd $(dirname $0)/.. && pwd)
. ${dotfiles_root}/scripts/common.sh

# create symblic link
cd ${dotfiles_root}/dotfiles
for linklist in "linklist.Base.txt" "linklist.$(uname).txt"; do
    [ ! -r "${linklist}" ] && continue

    __remove_linklist_comment "$linklist" | while read target link; do
        # open environments
        target=$(eval echo "${PWD}/${target}")
        link=$(eval echo "${link}")

        # symblic link
        __mkdir $(dirname ${link})
        __ln ${target} ${link}
    done
done

