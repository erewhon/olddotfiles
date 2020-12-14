# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# zmodload zsh/zprof    # Profile zshrc

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
export GOPATH=$( go env GOPATH )
export MANPATH="/usr/local/man:$MANPATH"

# set up "local" paths
path=(~/bin
      ~/bin/$( uname -s )
      ~/bin.local
      ~/.cargo/bin
      ~/.local/bin
      $( go env GOPATH )/bin
      $path)

# gpg-agent --daemon --use-standard-socket --pinentry-program /usr/local/bin/pinentry-mac

source ~/.shellrc

#
# Better Python setup using Pyenv.  (Ala rvm from Ruby world)
#    To see all versions available:  pyenv install -l
#
# Versions to try
#
#    pyenv install 3.6.4
#    pyenv 
#
# export WORKON_HOME=~/.ve
# mkdir -p $WORKON_HOME

# if [[ -d "$HOME/.pyenv" ]]; then
#     export PYENV_ROOT="$HOME/.pyenv"
#     export PATH="$PYENV_ROOT/bin:$PATH"
# fi

# if command -v pyenv 1>/dev/null 2>&1; then
#     eval "$(pyenv init -)"
# fi

#  if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

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

#
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
#

# https://github.com/robbyrussell/oh-my-zsh/tree/master/plugins/jira
#   $JIRA_URL - Your JIRA instance's URL
#   $JIRA_NAME - Your JIRA username; used as the default user for assigned/reported searches
#   $JIRA_PREFIX - Prefix added to issue ID arguments
#   $JIRA_RAPID_BOARD - Set to true if you use Rapid Board
#   $JIRA_DEFAULT_ACTION - Action to do when jira is called with no arguments; defaults to "new"

plugins=(ant
         chucknorris
         # colored-man-pages
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
         # ssh-agent
         supervisor
         svn
         tmux
         yarn
         zsh-autosuggestions   # Fish-like auto suggestions
        )

#zstyle :omz:plugins:ssh-agent agent-forwarding on
# Identities I need to find:  docker_do
zstyle :omz:plugins:ssh-agent identities id_rsa inet_rsa id_ecdsa

# User configuration

export ZSH=$HOME/.oh-my-zsh
source $ZSH/oh-my-zsh.sh

unsetopt correct_all
unsetopt correct

export ALTERNATE_EDITOR=""
export EDITOR="emacsclient -t"                  # $EDITOR should open in terminal
export VISUAL="emacsclient -c -a emacs"         # $VISUAL opens in GUI with non-daemon as alternate
export VERSION_CONTROL=numbered

HISTSIZE=1000000
SAVEHIST=$HISTSIZE

if [ -d /usr/java/current ]; then
  export JAVA_HOME=/usr/java/current
fi

alias e='emacsclient --no-wait --create-frame'
alias gdh='git diff HEAD'
alias mc='mc -x'

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

setopt EXTENDED_HISTORY

growl() { echo -e $'\e]9;'${1}'\007' ; return  ; }

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

#
# Mo' bling!   Show line numbers, ANSI escapes, long prompt in "less"
#
#export LESS='-C -j 10 -RMN'
#export LESSOPEN='|~/bin/lessfilter %s'

if command -v bat &> /dev/null
then
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
    alias less=bat
elif command -v batcat &> /dev/null
     # Debian-based systems call it "batcat" unfortunately
     export MANPAGER="sh -c 'col -bx | batcat -l man -p'"
     alias less=batcat
else
    export PAGER=less
fi

quote() {
    # 0. Show date
    # 1. pick a quote source (fortune, zippy?)
    # 2. pipe it to a viewer (parrotsay, cowsay, pokemonsay, lolcat)
    fortune | parrotsay
}
# figlet

gnusay() {
    cowsay -f gnu "$@"
}

whocall() {
    cowsay -f ghostbusters Who you Gonna Call | lolcat
}

starwars() {
    nc towel.blinkenlights.nl 23
}

#.# Better Git Logs.
### Using EMOJI-LOG (https://github.com/ahmadawais/Emoji-Log).

# Git Commit, Add all and Push — in one step.
function gcap() {
    git add . && git commit -m "$*" && git push
}

# NEW.
function gnew() {
    gcap "📦 NEW: $@"
}

# IMPROVE.
function gimp() {
    gcap "👌 IMPROVE: $@"
}

# FIX.
function gfix() {
    gcap "🐛 FIX: $@"
}

# RELEASE.
function grlz() {
    gcap "🚀 RELEASE: $@"
}

# DOC.
function gdoc() {
    gcap "📖 DOC: $@"
}

# TEST.
function gtst() {
    gcap "✅ TEST: $@"
}

if command -v exa 1>/dev/null 2>&1; then
    alias ll='exa -abghHl --time-style=long-iso'
    alias lll='exa -abghHl --time-style=long-iso --extended --git'
    alias tree='exa -abghHl --time-style=long-iso --tree --level=3'
fi

alias aq=asciiquarium

if [[ -f /etc/motd ]]; then
    cmp -s /etc/motd ~/.hushlogin ||
        tee ~/.hushlogin < /etc/motd
fi

#
# GPG related things
#
export VAULT_ADDR='http://127.0.0.1:8200'
export "GPG_TTY=$(tty)"
export "SSH_AUTH_SOCK=${HOME}/.gnupg/S.gpg-agent.ssh"

ssh-rekey() {
    echo "Rekeying ssh..."
    vault write -field=signed_key ssh-client-signer/sign/my-role \
          public_key=@$HOME/.ssh/id_ecdsa.pub > ~/.ssh/id_ecdsa-cert.pub
    ssh-keygen -Lf ~/.ssh/id_ecdsa-cert.pub
}


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
        command -v neofetch >/dev/null 2>&1 && \
            neofetch
    else
        quote
    fi
    
    # neofetch --size 25% --iterm2 ~/Documents/Pictures/Self/horsing_around.jpg
fi

# zprof          # Profile zshrc

# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
