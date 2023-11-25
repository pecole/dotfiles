# shellenv
if [[ -e /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  . "${ZDOTDIR}/homebrew.zsh"
fi

# sheldon
if type 'sheldon' &> /dev/null; then
  eval "$(sheldon source)"
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [[ -e /opt/homebrew/Cellar/source-highlight/3.1.9_5/bin/src-hilite-lesspipe.sh ]]; then
  export LESSOPEN="| /opt/homebrew/Cellar/source-highlight/3.1.9_5/bin/src-hilite-lesspipe.sh %s"
fi

# direnv
if type 'direnv' &> /dev/null; then
  eval "$(direnv hook zsh)"
fi

# anyenv setting
if type 'anyenv' &> /dev/null; then
  eval "$(anyenv init -)"
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

# autocomplite
if [ -e ~/.zsh/completions ]; then
  fpath=(~/.zsh/completions $fpath)
fi
# enable completion features
autoload -Uz compinit
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' rehash true
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

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
  bindkey ' '  zeno-auto-snippet
  bindkey '^m' zeno-auto-snippet-and-accept-line
  bindkey '^i' zeno-completion
  bindkey '^g' zeno-ghq-cd
  bindkey '^r' zeno-history-selection
  bindkey '^x' zeno-insert-snippet
fi

# To customize prompt, run `p10k configure` or edit ~/.zsh.d/.p10k.zsh.
[[ ! -f ~/.zsh.d/.p10k.zsh ]] || source ~/.zsh.d/.p10k.zsh
