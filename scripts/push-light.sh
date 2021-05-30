#!/bin/bash
#
# pushes a light version of certain config files to target host
#

if [ -z $1 ]; then
    echo "Usage: $0 <host>"
    exit 1
fi

cd ~/.dotfiles

rsync -Pavz \
      .zshrc-light \
      .vimrc-light \
      .bashrc-light \
      .tmux.conf-light \
      $1:
