# google-cloud-sdk (Macのみcaskでインストールされる)
__gcloud_sdk="${HOMEBREW_PREFIX:-$(brew --prefix)}/share/google-cloud-sdk"
if [[ -r "${__gcloud_sdk}/path.zsh.inc" ]]; then
  source "${__gcloud_sdk}/path.zsh.inc"
  # completion は重い(約90ms)ので .zshrc 側で zsh-defer により遅延読み込みする
  export GCLOUD_COMPLETION_INC="${__gcloud_sdk}/completion.zsh.inc"
fi
unset __gcloud_sdk

# alias home brew
alias powerup='brew update && brew upgrade && brew cleanup' # all upgrade
