#!/bin/bash

DOTFILES="$HOME/.dotfiles"

echo "Installing dotfiles..."

# Neovim
mkdir -p "$HOME/.config"
rm -rf "$HOME/.config/nvim"
ln -sf "$DOTFILES/nvim/.config/nvim" "$HOME/.config/nvim"
echo "  [ok] Neovim"

# tmux
rm -f "$HOME/.tmux.conf"
ln -sf "$DOTFILES/tmux/.tmux.conf" "$HOME/.tmux.conf"
echo "  [ok] tmux"

echo "Done!"

