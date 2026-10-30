#!/usr/bin/env bash

# Install oh-my-zsh if it doesn't exist. --keep-zshrc stops the installer
# replacing the ~/.zshrc symlink the link stage just created; --unattended
# stops it running chsh and exec'ing an interactive zsh mid-install.
if [ ! -d ~/.oh-my-zsh ]; then
    echo "Installing oh-my-zsh"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
fi

if [ "$(basename "${SHELL:-}")" != "zsh" ]; then
    echo "zsh is not your login shell. To change it, run: chsh -s $(command -v zsh)"
fi
