#!/bin/bash
# -*- Mode: shell-script -*-
#

NOW=$( date +%Y%m%d.%H%M%S )
TARGET=$HOME/.dotfiles.orig/$NOW/

mkdir -p $TARGET

echo Backing up files
for f in ~/.zshrc ~/.emacs.d ~/.gitignore ~/.gitconfig ~/.shellrc ~/.tmux.conf ~/.vimrc ~/.emacs; do
  mv -iv $f $TARGET
done

echo Linking in dotfiles
ln -sv ~/.dotfiles/.emacs     ~/
ln -sv ~/.dotfiles/.emacs.d/  ~/
ln -sv ~/.dotfiles/.gitconfig ~/
ln -sv ~/.dotfiles/.gitignore ~/
ln -sv ~/.dotfiles/.shellrc   ~/
ln -sv ~/.dotfiles/.tmux.conf ~/
ln -sv ~/.dotfiles/.vimrc     ~/
ln -sv ~/.dotfiles/.zshrc     ~/
ln -sv ~/.dotfiles/.zshenv    ~/
ln -sv ~/.dotfiles/.p10k.zsh  ~/
ln -sv ~/.dotfiles/.fzf.zsh   ~/

if command -v julia &> /dev/null; then
    mkdir -p ~/.julia/config
    ln -sv ~/.dotfiles/julia/startup.jl ~/.julia/config/startup.jl
fi
