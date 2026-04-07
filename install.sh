#!/bin/bash

DOTFILES="$HOME/.dotfiles"

echo "Installing dotfiles..."

# Neovim
mkdir -p "$HOME/.config"
ln -sf "$DOTFILES/nvim/.config/nvim" "$HOME/.config/nvim"

echo "Done!"

