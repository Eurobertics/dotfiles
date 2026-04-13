#!/bin/bash

DOTFILES="$HOME/.dotfiles"

cd $DOTFILES 
git pull

~/.dotfiles/install.sh

echo "Dotfiles updated!"
