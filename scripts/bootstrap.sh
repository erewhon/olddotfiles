#!/bin/bash
# -*- Mode: shell-script -*-
#

NOW=$( date +%Y%m%d.%H%M%S )
TARGET=$HOME/.dotfiles.orig/$NOW/

mkdir -p $TARGET

echo Backing up files
for f in ~/.zshrc ~/.emacs.d; do
  mv -iv $f $TARGET
done

echo Linking in dotfiles
ln -sv ~/.dotfiles/.emacs     ~/
ln -sv ~/.dotfiles/.emacs.d/  ~/
ln -sv ~/.dotfiles/.gitignore ~/
ln -sv ~/.dotfiles/.shellrc   ~/
ln -sv ~/.dotfiles/.tmux.conf ~/
ln -sv ~/.dotfiles/.vimrc     ~/
ln -sv ~/.dotfiles/.zshrc     ~/