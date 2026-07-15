#!/bin/sh
# scripts/*.sh から読み込まれる共通関数


# ログ出力
__info() { printf '[info] %s\n' "$*" >&2; }
__warn() { printf '[warn] %s\n' "$*" >&2; }
__error() { printf '[error] %s\n' "$*" >&2; }


# ディレクトリを再帰的に作成
__mkdir() {
    [ -e "$1" ] || { mkdir -p "$1" && __info "mkdir: $1"; }
}


# シンボリックリンクを作成
# すでに正しいリンクなら何もしない。別のリンクなら張り替え、
# 実ファイル・ディレクトリなら ${backup_dir} に退避してから作成する
__ln() {
    _target=$1
    _link=$2

    if [ -L "$_link" ]; then
        [ "$(readlink "$_link")" = "$_target" ] && return 0
        unlink "$_link"
    elif [ -e "$_link" ]; then
        __mkdir "${backup_dir:?}"
        mv "$_link" "${backup_dir}/" && __warn "backup: $_link -> ${backup_dir}/"
    fi

    ln -s "$_target" "$_link" && __info "ln: $_target -> $_link"
}


# シンボリックリンクを削除
# このリポジトリを指すリンク以外は誤爆防止のため削除しない
__unlink() {
    _link=$1

    [ -L "$_link" ] || return 0
    case "$(readlink "$_link")" in
        "${dotfiles_root:?}"/*) unlink "$_link" && __info "unlink: $_link" ;;
        *) __warn "skip (リポジトリ外を指すリンク): $_link" ;;
    esac
}


# linklistのコメント('#'以降)と空行を削除して出力
__remove_linklist_comment() {
    sed -e 's/[[:space:]]*#.*//' -e '/^[[:space:]]*$/d' "$1"
}


# インストール済みのHomebrewをPATHに通す
__load_brew() {
    command -v brew >/dev/null 2>&1 && return 0
    for _brew in /opt/homebrew/bin/brew /usr/local/bin/brew \
                 /home/linuxbrew/.linuxbrew/bin/brew "${HOME}/.linuxbrew/bin/brew"; do
        if [ -x "$_brew" ]; then
            eval "$("$_brew" shellenv)"
            return 0
        fi
    done
    return 1
}
