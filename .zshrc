#
# Stuff to only run in interactive shells
#
if [[ -o login ]]; then
    #
    # We don't want to go overboard (honest!), so display neofetch once per day, then fortune
    #
    NOW=$( date +%F )

    if ! cmp -s ~/.last_neofetch <( echo $NOW )
    then
        echo $NOW > ~/.last_neofetch
        command -v neofetch >/dev/null 2>&1 && neofetch
    else
        fortune | parrotsay
    fi

    # neofetch --size 25% --iterm2 ~/Documents/Pictures/Self/horsing_around.jpg
fi


# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#
# Zsh config.   A lot of oh-my-zsh, a lot of other things...
#

# add elements to path, uniquely
typeset -U path

# first, add "system" paths
path=(/usr/local/bin
      /usr/local/sbin
      $path)

#
# Set up different languages
#
export MANPATH="/usr/local/man:$MANPATH"

# set up "local" paths
path=(~/bin
      ~/bin/$( uname -s )
      ~/bin.local
      ~/.cargo/bin
      ~/.local/bin
      $path)

if command -v go &> /dev/null; then
    export GOPATH=$( go env GOPATH )
    path=($( go env GOPATH )/bin $path)

fi


source ~/.shellrc

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

plugins=(ant
         chucknorris
         docker
         extract
         git
         golang
         gradle
         httpie
         history
         jira
         lein
         npm
         osx
         perl
         repo
         supervisor
         svn
         tmux
         yarn
         zsh-autosuggestions   # Fish-like auto suggestions
        )

zstyle :omz:plugins:ssh-agent identities id_rsa inet_rsa id_ecdsa

# User configuration

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

[[ -s "$HOME/.dotfiles-local/dotfiles/.zshrc" ]] && source "$HOME/.dotfiles-local/dotfiles/.zshrc"
[[ -e "${HOME}/.iterm2_shell_integration.zsh" ]]  && source "${HOME}/.iterm2_shell_integration.zsh"

[[ -s "$HOME/.zshrc-local" ]] && source "$HOME/.zshrc-local"

#
# Syntax highlighting of command-line ala "fish"
#
[[ -s "/usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && \
    source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


if command -v bat &> /dev/null; then
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
    alias less=bat
    alias gitd='git diff --name-only --diff-filter=d | xargs bat --diff --show-all'
else
    export PAGER=less
    alias gitd='git diff'
fi


if command -v exa 1>/dev/null 2>&1; then
    alias ll='exa -abghHl --time-style=long-iso'
    alias lll='exa -abghHl --time-style=long-iso --extended --git'
    alias tree='exa -abghHl --time-style=long-iso --tree --level=3'
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

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
