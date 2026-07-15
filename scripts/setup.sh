#!/bin/sh
# Mac / Linux 共通のセットアップをまとめて実行する
#   1. シンボリックリンク作成 (link.sh)
#   2. Homebrewとパッケージのインストール (install.sh)
#   3. ログインシェルをzshに変更
#   4. Neovimプラグインを lazy-lock.json の状態に復元
set -eu

dotfiles_root=$(cd "$(dirname "$0")/.." && pwd)
. "${dotfiles_root}/scripts/common.sh"

"${dotfiles_root}/scripts/link.sh"
"${dotfiles_root}/scripts/install.sh"

# install.sh 内のPATH設定はこのシェルには残らないため、改めて通す
__load_brew || true

# ログインシェルをzshに変更
zsh_path=$(command -v zsh || true)
if [ -n "$zsh_path" ] && [ "$(basename "${SHELL:-}")" != "zsh" ]; then
    if ! grep -qx "$zsh_path" /etc/shells 2>/dev/null; then
        echo "$zsh_path" | sudo tee -a /etc/shells >/dev/null
    fi
    if chsh -s "$zsh_path"; then
        __info "ログインシェルを変更: $zsh_path"
    else
        __warn "chshに失敗しました。手動で変更してください: chsh -s $zsh_path"
    fi
fi

# Neovimプラグインを復元
if command -v nvim >/dev/null 2>&1; then
    __info "Neovimプラグインを復元中..."
    nvim --headless "+Lazy! restore" +qa \
        || __warn "Neovimプラグインの復元に失敗しました。nvim起動後に :Lazy restore を実行してください"
fi

__info "セットアップ完了。ターミナルを開き直してください"
