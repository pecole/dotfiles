# PATHの重複を防ぐ
# (zshをネストするたびに ~/bin などが積み重なるのを防ぐ)
typeset -U path fpath manpath

# user script
path=($path $HOME/bin)

# charset
export LANG=ja_JP.UTF-8

# editor
export EDITOR='nvim'

# less
export LESS='-g -i -M -R -S -W -z-4 -x4'

# pager
export PAGER=less

# zeno path
export ZENO_HOME=~/.config/zeno

# macOSの shell sessions を無効化する
# (ZDOTDIR配下に .zsh_sessions が作られるのを防ぐ)
export SHELL_SESSIONS_DISABLE=1
