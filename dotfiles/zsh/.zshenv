# Set zsh setting directory
[ -d ${HOME}/.zsh.d ] || return
export ZDOTDIR=${HOME}/.zsh.d

# Load .zshenv
[ -r ${ZDOTDIR}/.zshenv ] && . ${ZDOTDIR}/.zshenv

# local settings
[ -r ${HOME}/.zsh_local ] && . ${HOME}/.zsh_local

