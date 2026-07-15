#!/bin/sh
# linklist.*.txt に従ってシンボリックリンクを作成する
set -eu

dotfiles_root=$(cd "$(dirname "$0")/.." && pwd)
. "${dotfiles_root}/scripts/common.sh"

# リンク先に実ファイルが存在した場合の退避先(必要になったときだけ作成される)
backup_dir="${HOME}/.dotfiles.bak/$(date +%Y%m%d-%H%M%S)"

cd "${dotfiles_root}/dotfiles"
for linklist in "linklist.Base.txt" "linklist.$(uname -s).txt"; do
    [ -r "$linklist" ] || continue

    __remove_linklist_comment "$linklist" | while read -r target link; do
        # linklist内の ${HOME} などを展開
        link=$(eval echo "$link")

        __mkdir "$(dirname "$link")"
        __ln "${PWD}/${target}" "$link"
    done
done
