#!/bin/sh

# Mac
if [ "$(uname)" == 'Darwin' ]; then
    # homebrew
    if !(type "brew" > /dev/null 2>&1); then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    brew bundle --global
    # installed by brew
    # zeno
    # zsh
    # sheldon
    # wezterm
    # starship
fi

