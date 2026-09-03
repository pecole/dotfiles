#!/bin/sh
# =============================================================================
# link.sh — 設定ファイルへのシンボリックリンクを作る
#
# このリポジトリの中にある設定ファイルを、ホームディレクトリの
# あるべき場所から参照できるようにする。
# 例: dotfiles/zsh/.zshenv  →  ~/.zshenv
#
# どれをどこにリンクするかは dotfiles/linklist.*.txt に書いてある。
#
#   使い方: ./scripts/link.sh
# =============================================================================
set -eu   # -e エラーが出たら止まる / -u 未定義の変数を使ったら止まる

# このスクリプトの場所から、リポジトリの場所を求める
dotfiles_root=$(cd "$(dirname "$0")/.." && pwd)
. "${dotfiles_root}/scripts/common.sh"

# リンクを作る場所に本物のファイルがあったときの退避先。
# 実際に退避が必要になったときだけ作られる
backup_dir="${HOME}/.dotfiles.bak/$(date +%Y%m%d-%H%M%S)"


# linklist の1行ごとに呼ばれる処理
__link_one() {
    _source=$1      # リポジトリ内の実体
    _link_path=$2   # リンクを作る場所

    # リンクを置くフォルダが無ければ先に作る
    # (dirname は「パスからファイル名を除いた部分」を返すコマンド)
    __make_dir "$(dirname "$_link_path")"

    __make_link "$_source" "$_link_path"
}


__for_each_link __link_one
