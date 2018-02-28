#
# Bash config.
#
source ~/.shellrc

#
# Host completion
#
if [[ -s "$HOME/.hosts" ]]; then
     export HOSTFILE=~/.hosts
     complete -A hostname nc ping ssh s asc
fi

if [[ -d "$HOME/.pyenv" ]]; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
fi

#
# make lein not use cert
#
export HTTP_CLIENT="wget --no-check-certificate -O"


export PS1='\u@\h \w $ '

[[ -s "$HOME/.dotfiles.local/dotfiles/.bashrc" ]] && source "$HOME/.dotfiles.local/dotfiles/.bashrc"
[[ -s "$HOME/.bashrc-local" ]] && source "$HOME/.bashrc-local"

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
# If Pyenv exists, bootstrap it!
#
if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
fi
