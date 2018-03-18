#
# First, we set up the PATH, plus any language virtualization shims
#   (pyenv, nvm, etc).   We want to do this for both interactive
#   and non-interactive scripts.
#

export PATH="$HOME/bin:$PATH"

#
# If Pyenv exists, bootstrap it!
#
if [[ -d "$HOME/.pyenv" ]]; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
fi

if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
fi
 
#
# Non-interactive script, so stop at this point
#
[ -z "$PS1" ] && return

#
# If bash-it is available, use it.
#
if [[ -e ~/.bash_it ]]; then
    #
    # Bash It
    #    git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
    #    ~/.bash_it/install.sh
    #
    # bash-it enable plugin proxy
    # bash-it enable alias ag emacs git npm systemd tmux yarn
    #
    
    # BASH_IT_HTTP_PROXY
    # BASH_IT_HTTPS_PROXY
    export BASH_IT="$HOME/.bash_it"
    export BASH_IT_THEME='redline'
    
    # # powerline-multiline, powerline, redline
    # Make Bash-it reload itself automatically after enabling or
    # disabling aliases, plugins, and completions.
    # export BASH_IT_AUTOMATIC_RELOAD_AFTER_CONFIG_CHANGE=1

    export SCM_CHECK=true

    # Load Bash It
    source "$BASH_IT"/bash_it.sh
else
    #
    # Append history as we go
    #
    PROMPT_COMMAND='history -a'
    # PS1='$(if condition; then printf "\xe2\x9c\x93"; fi) $'

    if command -v powerline-go 1>/dev/null 2>&1; then
        function _update_ps1() {
            PS1="$(powerline-go -colorize-hostname -error $?)"
        }

        if [ "$TERM" != "linux" ]; then
            PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
        fi
    else
        PS1='\[\e[01;32m\]\[\e[1m\]\u@\h \[\e[36m\w\] \[\e[32m\]$(git branch 2>/dev/null | sed -n "s/* \(.*\)/\1 /p")\n\[\e[0m\]> \[\e[0m\]'
    fi
fi

#
# Bash config.
#
source ~/.shellrc

#
# Complete better!
#
[[ -s /usr/share/bash-completion/bash_completion ]] && \
    source /usr/share/bash-completion/bash_completion

if [[ -s "$HOME/.hosts" ]]; then
    export HOSTFILE=~/.hosts
    complete -A hostname nc ping ssh s asc
fi
#      29 complete -W "$(echo `cat ~/.ssh/known_hosts | cut -f 1 -d ' ' | sed -e s/,.*//g | uniq | grep -v "\["`;)" ssh

#
# Various settings
#
export IGNOREEOF=10
 
[[ -s "$HOME/.bashrc-local" ]] && source "$HOME/.bashrc-local"
 
unset MAILCHECK    # Don't check mail when opening terminal.
# export IRC_CLIENT='irssi'

#
# Make our history (and navigation) great again.
#
shopt -s histappend                # append history 

#
# store more in total, exclude dups and other stuff, and timestamp
#
export HISTIGNORE="&:[bf]g:exit"
export HISTCONTROL=ignoredups
export HISTFILESIZE=1000000
export HISTSIZE=1000000
export HISTTIMEFORMAT="%F %T "

shopt -s cdspell cmdhist

#
# Better editor!
#
export EDITOR=emacs
export VERSION_CONTROL=numbered

#
# ssh customization
#
SSH_ENV_DIR="$HOME/.ssh/$HOSTNAME"
SSH_ENV="$SSH_ENV_DIR/environment"

mkdir -p $SSH_ENV_DIR

function start_agent {
    echo "Initialising new SSH agent..."
    (umask 066; /usr/bin/ssh-agent > "${SSH_ENV}")
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add;
}
 
# Source SSH settings, if applicable
if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi
 
#
# make lein not use cert
#
export HTTP_CLIENT="wget --no-check-certificate -O"

#
# Bling
#
# [[ "$PS1" [[ && /usr/games/fortune | /usr/games/cowsay -n

# Pimp my screen!
if command -v neofetch >/dev/null 2>&1; then
    neofetch
    # elif command -v cowsay >/dev/null 2>&1; then
    #     fortune | cowsay
fi
