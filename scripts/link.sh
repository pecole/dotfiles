#!/bin/sh

dotfiles_root=$(cd $(dirname $0)/.. && pwd)
. ${dotfiles_root}/scripts/common.sh

# remove comments in linklist.txt
__remove_linklist_comment() {(
  # remove comment line to blank line
  sed -e 's/\s*#.*//' \
      -e '/^\s*$/d' \
      $1
)}

# create symblic link
cd ${dotfiles_root}/dotfiles
for linklist in "linklist.Unix.txt" "linklist.$(uname).txt"; do
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

if [ "$(uname)" == 'Darwin' ]; then
    if !(type "brwe" > /dev/null 2>&1); then
        eval 'brew bundle check'
    fi
fi
