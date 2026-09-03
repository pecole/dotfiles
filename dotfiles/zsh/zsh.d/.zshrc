# 共通関数 (__cache_eval / __defer / __load_brew / __compinit / __zeno_bindkeys)
source "${ZDOTDIR}/lib.zsh"

# shellenv (Apple Silicon / Intel Mac / Linuxbrew)
if __load_brew; then
  source "${ZDOTDIR}/homebrew.zsh"
fi

# sheldon
# 出力は plugins.toml が変わらない限り同じなのでキャッシュする
if (( $+commands[sheldon] )); then
  __cache_eval sheldon "${XDG_CONFIG_HOME:-$HOME/.config}/sheldon/plugins.toml" sheldon source
fi

# 以降 __defer は zsh-defer が使えれば遅延実行になる
# (zsh-defer は登録順に実行されるので compinit 後に走らせたいものもここに積む)

# gcloud completion（約90ms）
[[ -r $GCLOUD_COMPLETION_INC ]] && __defer source "$GCLOUD_COMPLETION_INC"

# gh completion (compdef を使うため compinit の後に読む必要がある)
(( $+commands[gh] )) && __defer __cache_eval gh-completion "$commands[gh]" gh completion -s zsh

# fzf のキーバインドと補完
(( $+commands[fzf] )) && __defer __cache_eval fzf "$commands[fzf]" fzf --zsh

# zeno のキーバインド (zeno 本体も同じキューで遅延ロードされる)
__defer __zeno_bindkeys

# cargo
if [[ -r "$HOME/.cargo/env" ]]; then
  . "$HOME/.cargo/env"
fi

# mise
# activate の出力には解決済みのPATHが埋め込まれるためキャッシュできない
__mise=${commands[mise]:-$HOME/.local/bin/mise}
if [[ -x $__mise ]]; then
  eval "$($__mise activate zsh)"
fi
unset __mise

# starship
if (( $+commands[starship] )); then
  __cache_eval starship "$commands[starship]" starship init zsh
fi

# PATHの重複を除去する
# typeset -U は配列への代入でしか効かず、gcloud の path.zsh.inc や
# mise の `export PATH='...'` のような文字列一括代入では重複が残るため、
# PATHを触る処理をすべて終えたここで配列に代入し直して正規化する
path=($path)

# option
setopt autocd              # change directory just by typing its name
#setopt correct            # auto correct mistakes
setopt interactivecomments # allow comments in interactive mode
setopt magicequalsubst     # enable filename expansion for arguments of the form ‘anything=expression’
setopt nonomatch           # hide error message if there is no match for the pattern
setopt notify              # report the status of background jobs immediately
setopt numericglobsort     # sort filenames numerically when it makes sense
setopt promptsubst         # enable command substitution in prompt
setopt AUTO_PARAM_KEYS     # 環境変数を補完
setopt inc_append_history  # 他のzshと履歴を共有
setopt share_history

# History configurations
HISTFILE=${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history
[[ -d ${HISTFILE:h} ]] || mkdir -p "${HISTFILE:h}"
HISTSIZE=1000
SAVEHIST=2000
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it

# 履歴を全件表示する (引数なしの history は直近16件しか出さない)
alias history='history 1'

# configure key keybindings
bindkey -e # emacs key bindings

# alias ls (BSD lsとGNU lsでカラーオプションが異なる)
if [[ "$OSTYPE" == darwin* ]]; then
  alias ls='ls -GF'
else
  alias ls='ls -F --color=auto'
fi
alias la='ls -la'
alias ll='ls -l'

# alias nvim
if (( $+commands[nvim] )); then
  alias vim='nvim'
fi

# 計測用: ~/.zshenv 先頭の `zmodload zsh/zprof` を有効にすると結果を表示する
(( $+builtins[zprof] )) && zprof
