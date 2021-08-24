# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# some more ls aliases
alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

function _update_ps1() {
    PS1="(${APP_NAME})$(/usr/local/bin/powerline-go -error $? -modules "venv,user,cwd,perms,git,exit,root")"
}

#if [ "$TERM" != "linux" ] && [ -f "/usr/local/bin/powerline-go" ]; then
#    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
#fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

if [ -f /opt/ros/${ROS_DISTRO}/setup.bash ]; then
    source "/opt/ros/${ROS_DISTRO}/setup.bash"
fi

# Include custom options if needed
if [ -f ${MOVAI_HOME}/movai.bash ]; then
    source ${MOVAI_HOME}/movai.bash
fi

export PYTHONPATH=${APP_PATH}:${PYTHONPATH}

cat ${MOVAI_HOME}/.welcome

printf "Welcome! Have fun!\n"