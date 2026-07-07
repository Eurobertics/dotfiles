#!/bin/bash

DOTFILES="$HOME/.dotfiles"

echo "Installing dotfiles..."

# Neovim
mkdir -p "$HOME/.config"
rm -rf "$HOME/.config/nvim"
ln -sf "$DOTFILES/nvim/.config/nvim" "$HOME/.config/nvim"
echo "  [ok] Neovim"

# Clangd
rm -rf "$HOME/.config/clangd"
ln -sf "$DOTFILES/clangd/.config/clangd" "$HOME/.config/clangd"
echo "  [ok] clangd"

# tmux
rm -f "$HOME/.tmux.conf"
ln -sf "$DOTFILES/tmux/.tmux.conf" "$HOME/.tmux.conf"
echo "  [ok] tmux"

# git
rm -f "$HOME/.gitconfig"
ln -sf "$DOTFILES/git/.gitconfig" "$HOME/.gitconfig"
echo "  [ok] git"

echo "Done!"

