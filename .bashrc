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

#
# make lein not use cert
#
export HTTP_CLIENT="wget --no-check-certificate -O"


export PS1='\u@\h \w $ '

[[ -s "$HOME/.dotfiles.local/dotfiles/.bashrc" ]] && source "$HOME/.dotfiles.local/dotfiles/.bashrc"

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
