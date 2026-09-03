#!/bin/sh
# =============================================================================
# install.sh — Homebrew と、~/.Brewfile に書かれたパッケージを入れる
#
# Homebrew は Mac / Linux 共通で使えるパッケージ管理ツール。
# ~/.Brewfile は link.sh が作るリンクなので、先に link.sh を実行しておくこと。
#
#   使い方: ./scripts/install.sh
# =============================================================================
set -eu

dotfiles_root=$(cd "$(dirname "$0")/.." && pwd)
. "${dotfiles_root}/scripts/common.sh"


# -----------------------------------------------------------------------------
# Linux で Homebrew を入れるのに必要なものを先に用意する
#
# Linux版のHomebrewは一部をソースからビルドするため、コンパイラなどが要る。
# ディストリビューションごとにパッケージ管理ツールが違うので順に調べる
# -----------------------------------------------------------------------------
__install_linux_prerequisites() {
    if command -v apt-get >/dev/null 2>&1; then
        # Debian / Ubuntu 系
        sudo apt-get update
        sudo apt-get install -y build-essential procps curl file git zsh
    elif command -v dnf >/dev/null 2>&1; then
        # Fedora / RHEL 系
        sudo dnf install -y gcc gcc-c++ make procps-ng curl file git zsh
    elif command -v pacman >/dev/null 2>&1; then
        # Arch 系
        sudo pacman -Sy --noconfirm --needed base-devel procps-ng curl file git zsh
    else
        __warn "未対応のパッケージマネージャです。gcc/curl/file/git/zsh を手動でインストールしてください"
    fi
}


# -----------------------------------------------------------------------------
# 1. Homebrew 本体
# -----------------------------------------------------------------------------
if ! __load_brew; then
    # 見つからなかったので新しく入れる
    [ "$(uname -s)" = "Linux" ] && __install_linux_prerequisites

    # 公式のインストーラを取ってきて実行する。
    # NONINTERACTIVE=1 は「途中で確認を求めない」という指定
    NONINTERACTIVE=1 /bin/bash -c \
        "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # 入れた直後は PATH が通っていないので、改めて探す
    if ! __load_brew; then
        __error "Homebrewのインストールに失敗しました"
        exit 1
    fi
fi


# -----------------------------------------------------------------------------
# 2. パッケージ
# -----------------------------------------------------------------------------
if [ ! -r "${HOME}/.Brewfile" ]; then
    __error "~/.Brewfile がありません。先に link.sh を実行してください"
    exit 1
fi

# --global は「~/.Brewfile を読む」という指定
brew bundle --global
