# What's here

My scripts and config for various Unix-like machines and shells, built
and rebuilt over the years.

My preference these days is to have zsh, but on some systems I'm
forced to use bash.   At some point, I hope to bring it closer to zsh,
feature-parity-wise.  (If not bling wise.)

# Backstory

I had originally maintained my dotfiles in a private repo, checked out
to ~/.dotfiles, with various things symlinked into $HOME.    It was
all manually managed, and hard to manage the way I had it set up.

While searching for a better solution, I ran across this article that
describes a much simpler technique:

    https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/

So in February 2018 I switched over to use it.   Even though I have
history going back on various machines to the early 1990s, I'm
consolidating using this.   Maybe one day I'll backfill the history as
I try to recover some ancient things I used to do.

# Prerequisites

## Mac

- Install Homebrew
- Install zsh
- Install oh-my-zsh (which changes default shell)
- Install Emacs from homebrew cask
- Git
- Install nerd fonts!
- Install Karibiner
- Pygmentize
- brew install zsh-syntax-highlighting
- brew install pyenv pyenv-virtualenv pyenv-virtualenvwrapper

## Linux

- Git

## Better Python

Using Pyenv:

- git clone https://github.com/pyenv/pyenv.git ~/.pyenv


# Things Remaining

https://www.jetbrains.com/help/idea/exporting-and-importing-settings.html
https://unix.stackexchange.com/questions/260813/bash-hushlogin-keep-last-login-time-and-host
