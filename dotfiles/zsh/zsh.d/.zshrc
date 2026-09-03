# shellenv (Apple Silicon / Intel Mac / Linuxbrew)
for __brew in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
  if [[ -x $__brew ]]; then
    eval "$($__brew shellenv)"
    . "${ZDOTDIR}/homebrew.zsh"
    break
  fi
done
unset __brew

# sheldon
if type 'sheldon' &> /dev/null; then
  eval "$(sheldon source)"
fi

# 遅延読み込み（zsh-defer は sheldon が最初に読み込む）
if (( $+functions[zsh-defer] )); then
  # gcloud completion（約90ms）
  [[ -r $GCLOUD_COMPLETION_INC ]] && zsh-defer source "$GCLOUD_COMPLETION_INC"
elif [[ -r $GCLOUD_COMPLETION_INC ]]; then
  source "$GCLOUD_COMPLETION_INC"
fi

# cargo
if [[ -e "$HOME/.cargo/env" ]]; then
  . "$HOME/.cargo/env"
fi

# mise
if [[ -e "$HOME/.local/bin/mise" ]]; then
  eval "$($HOME/.local/bin/mise activate zsh)"
fi

# starship
if type 'starship' &> /dev/null; then
  eval "$(starship init zsh)"
fi

# gh setting (補完をキャッシュして起動を高速化)
if type 'gh' &> /dev/null; then
  _gh_comp="${ZDOTDIR}/.gh-completion.zsh"
  if [[ ! -f $_gh_comp || $_gh_comp -ot $(command -v gh) ]]; then
    gh completion -s zsh > "$_gh_comp"
  fi
  # compdef を使うため compinit(zsh-defer) の後に読む必要がある
  if (( $+functions[zsh-defer] )); then
    zsh-defer source "$_gh_comp"
  else
    source "$_gh_comp"
  fi
  unset _gh_comp
fi

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
HISTFILE=$ZDOTDIR/.zsh-history
HISTSIZE=1000
SAVEHIST=2000
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it

# force zsh to show the complete history
alias history="history"

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
if type 'nvim' &> /dev/null; then
  alias vim='nvim'
fi

# zeno
# zeno 本体を zsh-defer で遅延ロードしているため、キーバインドも同じキューに積む
# （zsh-defer は登録順に実行するので zeno の source 完了後に走る）
if (( $+functions[zsh-defer] )); then
  zsh-defer -c '
    if [[ -n $ZENO_LOADED ]]; then
      bindkey "^m" zeno-auto-snippet-and-accept-line
      bindkey "^i" zeno-completion
      bindkey "^g" zeno-ghq-cd
      bindkey "^r" zeno-history-selection
      bindkey "^x" zeno-insert-snippet
    fi
  '
elif [[ -n $ZENO_LOADED ]]; then
  bindkey '^m' zeno-auto-snippet-and-accept-line
  bindkey '^i' zeno-completion
  bindkey '^g' zeno-ghq-cd
  bindkey '^r' zeno-history-selection
  bindkey '^x' zeno-insert-snippet
fi

if (which zprof > /dev/null 2>&1) ;then
  zprof
fi
