#!/bin/sh
# link.sh が作成したシンボリックリンクを削除する
set -eu

dotfiles_root=$(cd "$(dirname "$0")/.." && pwd)
. "${dotfiles_root}/scripts/common.sh"

cd "${dotfiles_root}/dotfiles"
for linklist in "linklist.Base.txt" "linklist.$(uname -s).txt"; do
    [ -r "$linklist" ] || continue

    __remove_linklist_comment "$linklist" | while read -r target link; do
        # linklist内の ${HOME} などを展開
        link=$(eval echo "$link")

        __unlink "$link"
    done
done
