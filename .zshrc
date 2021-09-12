arch_name="$(uname -m)"
os_name="$(uname -s)"

if [[ "${os_name}" == "Darwin" ]]; then
    # MacOS.  Distinguish between M1 and x86.
    if [[ "${arch_name}" == "arm64" ]]; then
        export HOMEBREW_PREFIX="/opt/homebrew";
        export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
        export HOMEBREW_REPOSITORY="/opt/homebrew";
        export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}";
        export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:";
        export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";
    else
        export HOMEBREW_PREFIX="/usr/local";
        export HOMEBREW_CELLAR="/usr/local/Cellar";
        export HOMEBREW_REPOSITORY="/usr/local/Homebrew";
        export PATH="/usr/local/bin:/usr/local/sbin${PATH+:$PATH}";
        export MANPATH="/usr/local/share/man${MANPATH+:$MANPATH}:";
        export INFOPATH="/usr/local/share/info:${INFOPATH:-}";
    fi
else
    # For Linux and others, we add /usr/local/bin and /usr/local/sbin unconditionally
    export PATH="/usr/local/bin:/usr/local/sbin${PATH+:$PATH}";
fi

#
# Stuff to only run in interactive shells and *not* in TMUX?
#
if [[ -o login ]]; then
    #
    # We don't want to go overboard (honest!), so display neofetch once per day, then fortune
    #
    NOW=$( date +'%F %H:%M' )

    if ! cmp -s ~/.last_neofetch <( echo $NOW )
    then
        echo $NOW > ~/.last_neofetch
        command -v neofetch >/dev/null 2>&1 && neofetch --iterm2 ~/Documents/Pictures/Backgrounds/Unsplash/
    else
        # do nothing...   nice and clean!
        
        # if command -v fortune &> /dev/null; then
        #     if [[ -z "$TMUX" ]]; then
        #         fortune | parrotsay
        #     fi
        # else
        #     # If fortunate isn't available, just unconditionally show neofetch?
        #     command -v neofetch >/dev/null 2>&1 && neofetch
        # fi
    fi

    # neofetch --size 25% --iterm2 ~/Documents/Pictures/Self/horsing_around.jpg

    # figlet -w 200-k -f "$(brew --prefix)/share/figlet/fonts/larry3d.flf" "$(printf '%.0s ' {0..5})Hey,"
    # figlet -w 200 -k -f "$(brew --prefix)/share/figlet/fonts/larry3d.flf" "$(printf '%.0s ' {0..5})$(whoami)"
fi


# XDG_CONFIG_HOME



# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#
# Zsh config.   A lot of oh-my-zsh, a lot of other things...
#

export MANPATH="/usr/local/man:$MANPATH"
export DISABLE_AUTO_UPDATE="true"         # Do not auto update oh my zsh
                                          # Run "omz update" to manually update.

# add elements to path, uniquely
typeset -U path

# set up paths
path=(~/bin               # link to ~/.dotfiles/bin
      ~/bin/$( uname -s ) # deprecate
      ~/bin.local         # deprecate / consolidate
      ~/.cargo/bin
      ~/.local/bin        # local binaries
      ~/Library/Python/3.9/bin
      # /usr/local/bin
      # /usr/local/sbin
      /snap/bin
      ~/.emacs.d/bin
      $path)

#
# Set up different languages
#
if command -v go &> /dev/null; then
    export GOPATH=$( go env GOPATH )
    path=($( go env GOPATH )/bin $path)

fi

source ~/.shellrc      # move to ~/.dotfiles path to eliminate need for symlink!

#
# It's the 21st century.  Why are our Unix terminals so boring?  Back
# in the 1980s we had more colorful ANSI terminals.   Well, turns out we
# *can* have color.  We just need to turn on the bling.   And thanks
# to Google, Stackoverflow, and Github Gist's, it's easy!
#

# Powerline10k
ZSH_THEME="powerlevel10k/powerlevel10k"

ENABLE_CORRECTION="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
HIST_STAMPS="yyyy-mm-dd"
setopt AUTO_CD                       # You can just type a directory and CD there

# https://github.com/robbyrussell/oh-my-zsh/tree/master/plugins/jira
#   $JIRA_URL - Your JIRA instance's URL
#   $JIRA_NAME - Your JIRA username; used as the default user for assigned/reported searches
#   $JIRA_PREFIX - Prefix added to issue ID arguments
#   $JIRA_RAPID_BOARD - Set to true if you use Rapid Board
#   $JIRA_DEFAULT_ACTION - Action to do when jira is called with no arguments; defaults to "new"

plugins=(ansible     # aliases of note: a
         aws
         # bgnotify  # requires terminal-notifier.  Notify after long running commands
         brew        # aliases of note: brews, bubo, bubu
         chucknorris # chuck, chuck_cow
         docker
         git         # aliases of note: g, ga, gcmsg, gdca
                     #   grup, ggpull, glg, glgp, glo, glol,
                     #   gupa
         golang
         gradle      # can just type 'gradle' and it will use wrapper
         httpie
         history
         jira
         kubectl
         microk8s
         mosh
         npm
         ripgrep
         supervisor
         tmux
         yarn
         zsh-autosuggestions   # Fish-like auto suggestions
        )

# User configuration

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

export ZSH=$HOME/.oh-my-zsh
source $ZSH/oh-my-zsh.sh

unsetopt correct_all
unsetopt correct

# export ALTERNATE_EDITOR=""
# export EDITOR="emacsclient -t"                  # $EDITOR should open in terminal
# export VISUAL="emacsclient -c -a emacs"         # $VISUAL opens in GUI with non-daemon as alternate
export VERSION_CONTROL=numbered

HISTSIZE=1000000
SAVEHIST=$HISTSIZE

if [ -d /usr/java/current ]; then
  export JAVA_HOME=/usr/java/current
fi

setopt EXTENDED_HISTORY

compdef _hosts asc
compdef _hosts bsc

export GROOVY_HOME=/usr/local/opt/groovy/libexec

#
# Syntax highlighting of command-line ala "fish"
#
[[ -s "/usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && \
    source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


if command -v bat &> /dev/null; then
    export BAT_THEME=Dracula
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
    alias less=bat
    alias gitd='git diff --name-only --diff-filter=d | xargs bat --diff --show-all'
    tailf() { tail -f "$@" | bat --paging=never -l log }
elif [[ -f /usr/bin/batcat ]]; then
    export BAT_THEME=Dracula
    export MANPAGER="sh -c 'col -bx | batcat -l man -p'"
    alias less=batcat
    alias gitd='git diff --name-only --diff-filter=d | xargs batcat --diff --show-all'
    tailf() { tail -f "$@" | batcat --paging=never -l log }
else
    export PAGER=less
    alias gitd='git diff'
    alias tailf='tail -f'
fi


if command -v exa 1>/dev/null 2>&1; then
    alias ll='exa -abghHl --time-style=long-iso --git'
    alias lll='exa -abghHl --time-style=long-iso --extended --git'
    alias tree='exa -abghHl --time-style=long-iso --tree --level=3'
fi

if command -v zoxide 1>/dev/null 2>&1; then
    eval "$(zoxide init zsh)"
fi

#
# Only show message of the day when it changes, otherwise suppress it.
#
if [[ -f /etc/motd ]]; then
    cmp -s /etc/motd ~/.hushlogin ||
        tee ~/.hushlogin < /etc/motd
fi

#
# Enhanced history
#   https://raehik.github.io/2014/10/12/record-additional-full-zsh-history/
#
zshaddhistory() {
    # prepend the current epoch time
    # $1 includes terminating newline already (see zshmisc(1))
    echo -n "$(date "+%s") $1" >> "$HOME/.zsh_full_history"
}

# clean up the line when exiting with Ctrl-D                                    
# if Ctrl-D is hit, there isn't a terminating newline -- so we'll add a  
# useful message which probably won't ever be written (! specifies an    
# event, so it'll only work surrounded in quotes                         
# zshexit() {
#    echo "!EXIT! $(date "+%s")" >> "$HOME/.zsh_full_history"
# }

[[ -s "$HOME/.zshrc-local" ]] && source "$HOME/.zshrc-local"

# On Mac
# [ -f ~/.fzf.zsh -a -f /usr/local/opt/fzf/shell/key-bindings.zsh ] && source ~/.fzf.zsh

# On Debian-based system
# [ -f ~/.fzf.zsh -a -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#
# experimental: McFly.  Need to troubleshoot why this sometimes doesn't seem to bind!
#
if command -v mcfly &> /dev/null; then
    # export MCFLY_FUZZY=true
    # eval "$(mcfly init zsh)"
    [[ ! -f ~/.dotfiles/mcfly.zsh ]] || source ~/.dotfiles/mcfly.zsh
fi

#
# Make sure things are bound correctly!  (But why!?)
#
# bindkey '^R' mcfly-history-widget


# add arch to prompt.  look at powrelevel10

# if [ "${arch_name}" = "x86_64" ]; then
#     if [ "$(sysctl -in sysctl.proc_translated)" = "1" ]; then
#         echo "Running on Rosetta 2"
#     else
#         echo "Running on native Intel"
#     fi 
# elif [ "${arch_name}" = "arm64" ]; then
#     echo "Running on ARM"
# else
#     echo "Unknown architecture: ${arch_name}"
# fi
# 
# return

