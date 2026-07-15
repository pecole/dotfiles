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
