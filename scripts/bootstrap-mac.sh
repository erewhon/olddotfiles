#!/bin/bash
# -*- Mode: shell-script -*-
#
# Macs-specific bootstrap commands
#


#
# Turns off icons on desktop.  (I like keeping it clean.)
#
defaults write com.apple.finder CreateDesktop false
killall Finder

# defaults write -g InitialKeyRepeat -int 15 # normal minimum is 15 (225 ms)
defaults write -g KeyRepeat -int 1 # normal minimum is 2 (30 ms)
