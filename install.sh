#!/bin/bash

DOTFILES="$HOME/.dotfiles"

echo "Installing dotfiles..."

# Neovim
mkdir -p "$HOME/.config"
# Alte konfiguration weg räumen falls .config existierte
rm -rf "$HOME/.config/nvim"
ln -sf "$DOTFILES/nvim/.config/nvim" "$HOME/.config/nvim"

echo "Done!"

