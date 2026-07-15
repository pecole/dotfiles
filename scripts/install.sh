#!/bin/sh
# Homebrewと ~/.Brewfile のパッケージをインストールする (Mac / Linux)
set -eu

dotfiles_root=$(cd "$(dirname "$0")/.." && pwd)
. "${dotfiles_root}/scripts/common.sh"

# Linux: Homebrewのビルドに必要な前提パッケージとzshを入れる
__install_linux_prerequisites() {
    if command -v apt-get >/dev/null 2>&1; then
        sudo apt-get update
        sudo apt-get install -y build-essential procps curl file git zsh
    elif command -v dnf >/dev/null 2>&1; then
        sudo dnf install -y gcc gcc-c++ make procps-ng curl file git zsh
    elif command -v pacman >/dev/null 2>&1; then
        sudo pacman -Sy --noconfirm --needed base-devel procps-ng curl file git zsh
    else
        __warn "未対応のパッケージマネージャです。gcc/curl/file/git/zsh を手動でインストールしてください"
    fi
}

# Homebrew本体
if ! __load_brew; then
    [ "$(uname -s)" = "Linux" ] && __install_linux_prerequisites

    NONINTERACTIVE=1 /bin/bash -c \
        "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    if ! __load_brew; then
        __error "Homebrewのインストールに失敗しました"
        exit 1
    fi
fi

# パッケージ (~/.Brewfile は link.sh が作成する)
if [ ! -r "${HOME}/.Brewfile" ]; then
    __error "~/.Brewfile がありません。先に link.sh を実行してください"
    exit 1
fi
brew bundle --global
