#
# I use oh-my-zsh
#
export ZSH=$HOME/.oh-my-zsh

#
# It's the 21st century.  Why are our Unix terminals so boring?  Back
# in the 1980s we had more colorful ANSI terminals.   Well, turns out we
# *can* have color.  We just need to turn on the bling.   And thanks
# to Google, Stackoverflow, and Github Gist's, it's easy!
#

# Turn on Powerline9k prompt in zsh with plenty o' bling, add custom font
# for gratuitious icons.

# https://gist.github.com/kevin-smets/8568070
# git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir rbenv vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs history battery time)
POWERLEVEL9K_MODE='nerdfont-complete'

#
# Fish-like path shortening
#
POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
POWERLEVEL9K_SHORTEN_DELIMITER=""
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_from_right"

# POWERLEVEL9K_SHORTEN_STRATEGY="truncate_to_unique"
# POWERLEVEL9K_SHORTEN_DIR_LENGTH=3    # Shorten path; useful for deep directories
# Uncommenting the below will suppress my local user in the prompt.   However,
#   when running Docker locally, it leads to Inception issues.  :-)
# DEFAULT_USER="erewhon"
ZSH_THEME="powerlevel9k/powerlevel9k"

ENABLE_CORRECTION="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
HIST_STAMPS="yyyy-mm-dd"
setopt AUTO_CD                       # You can just type a directory and CD there

#
# Let's make "less" and "man" a bit more colorful
#   https://unix.stackexchange.com/questions/119/colors-in-man-pages
#   (actually, used colored-man-pages zsh plugin)
#

# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
#  possible: pyenv
#             battery

# https://github.com/robbyrussell/oh-my-zsh/tree/master/plugins/jira
# $JIRA_URL - Your JIRA instance's URL
# $JIRA_NAME - Your JIRA username; used as the default user for assigned/reported searches
# $JIRA_PREFIX - Prefix added to issue ID arguments
# $JIRA_RAPID_BOARD - Set to true if you use Rapid Board
# $JIRA_DEFAULT_ACTION - Action to do when jira is called with no arguments; defaults to "new"

plugins=(ant
         cap
         colored-man-pages
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
         repo
         supervisor
         svn
         tmux
         yarn
         zsh-autosuggestions   # Fish-like auto suggestions
        )

#         ssh-agent
# zstyle :omz:plugins:ssh-agent agent-forwarding on
# zstyle :omz:plugins:ssh-agent id_rsa github_rsa hermes_id_rsa inet_rsa do_rsa
#zstyle :omz:plugins:ssh-agent identities id_rsa inet_rsa

# User configuration

source $ZSH/oh-my-zsh.sh

export GOPATH=$( go env GOPATH )
export MANPATH="/usr/local/man:$MANPATH"

# add elements to path, uniquely
typeset -U path

path=(~/bin
      ~/bin.local
      /usr/local/bin
      /usr/local/sbin
      /usr/local/share/pypy
      $( go env GOPATH )/bin
      $path)

export ALTERNATE_EDITOR=emacs EDITOR=emacsclient VISUAL=emacsclient
export VERSION_CONTROL=numbered

if [ -d /usr/java/current ]; then
  export JAVA_HOME=/usr/java/current
fi

alias c=cd
alias d=dirs
alias e='emacsclient --no-wait --create-frame'
alias p=pushd
alias ,=popd
alias s=ssh
alias j=jobs
alias gdh='git diff HEAD'
alias mc='mc -x'

#
# Simple dotfile management, ala
#      https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/
#
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
config config --local status.showUntrackedFiles no

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    
    # LS colors, made with http://geoff.greer.fm/lscolors/
#    export LSCOLORS="exfxcxdxbxegedabagacad"
#    export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:'
    #    export GREP_COLOR='1;33'
    # https://github.com/seebi/dircolors-solarized
    # https://www.hanselman.com/blog/SettingUpAShinyDevelopmentEnvironmentWithinLinuxOnWindows10.aspx
fi

gack() { ack -g $* }
eack() { emacsclient -n $( ack -g $* ) }

# disown command?
#alias -g subl=subl

setopt EXTENDED_HISTORY


# http://stackoverflow.com/questions/714421/what-is-an-easy-way-to-do-a-sorted-diff-between-two-files
function diffs() {
        diff "${@:3}" <(sort "$1") <(sort "$2")
}

growl() { echo -e $'\e]9;'${1}'\007' ; return  ; }

compdef _hosts asc
compdef _hosts bsc

#[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"  # This loads RVM into a shell session.

#PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

export GROOVY_HOME=/usr/local/opt/groovy/libexec


#
# Node
#
export NODE_MODULES=/usr/local/share/npm/lib/node_modules

# source $HOME/.rvm/scripts/rvm

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

[[ -s "$HOME/.dotfiles-local/dotfiles/.zshrc" ]] && source "$HOME/.dotfiles-local/dotfiles/.zshrc"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

#
# Syntax highlighting of command-line ala "fish"
#
[[ -s "/usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && \
    source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

#
# Mo' bling!   Show line numbers, ANSI escapes, long prompt in "less"
#
export LESS='-RMN'
export LESSOPEN='|~/bin/lessfilter %s'

#a
# Stuff to only run in interactive shells
#
if [[ -o login ]]; then

    # Pimp my screen!
    command -v neofetch >/dev/null 2>&1 && \
        neofetch

    # neofetch --size 25% --iterm2 ~/Documents/Pictures/Self/horsing_around.jpg

fi
export PATH="/usr/local/opt/e2fsprogs/bin:$PATH"
export PATH="/usr/local/opt/e2fsprogs/sbin:$PATH"
