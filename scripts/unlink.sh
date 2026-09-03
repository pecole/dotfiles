#!/bin/sh
# link.sh が作成したシンボリックリンクを削除する
set -eu

dotfiles_root=$(cd "$(dirname "$0")/.." && pwd)
. "${dotfiles_root}/scripts/common.sh"

__unlink_entry() {
    __unlink "$2"
}

__each_linklist_entry __unlink_entry
