# shellenv
if [[ -e /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  . "${ZDOTDIR}/homebrew.zsh"
fi

# sheldon
if type 'sheldon' &> /dev/null; then
  eval "$(sheldon source)"
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

# gh setting
if type 'gh' &> /dev/null; then
  eval "$(gh completion -s zsh)"
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

# alias ls
alias ls='ls -GF'
alias la='ls -laG'
alias ll='ls -lG'

# alias nvim
if type 'nvim' &> /dev/null; then
  alias vim='nvim'
fi

# zeno
if [[ -n $ZENO_LOADED ]]; then
#  bindkey ' '  zeno-auto-snippet
  bindkey '^m' zeno-auto-snippet-and-accept-line
  bindkey '^i' zeno-completion
  bindkey '^g' zeno-ghq-cd
  bindkey '^r' zeno-history-selection
  bindkey '^x' zeno-insert-snippet
fi

if (which zprof > /dev/null 2>&1) ;then
  zprof
fi
