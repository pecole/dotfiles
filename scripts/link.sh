#!/bin/sh
# linklist.*.txt に従ってシンボリックリンクを作成する
set -eu

dotfiles_root=$(cd "$(dirname "$0")/.." && pwd)
. "${dotfiles_root}/scripts/common.sh"

# リンク先に実ファイルが存在した場合の退避先(必要になったときだけ作成される)
backup_dir="${HOME}/.dotfiles.bak/$(date +%Y%m%d-%H%M%S)"

__link_entry() {
    __mkdir "$(dirname "$2")"
    __ln "$1" "$2"
}

__each_linklist_entry __link_entry
