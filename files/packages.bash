#!/bin/bash
# Add user to sudoers

SUDO_COMMANDS=(
    /usr/bin/apt-get
    /usr/bin/apt
    /usr/bin/apt-key
    /usr/bin/apt-cache
    /usr/bin/apt-mark
    /usr/bin/add-apt-repository
)

# Setup available sudo commands for user movai
adduser movai sudo
touch /etc/sudoers.d/movai
for SUDO_COMMAND in ${SUDO_COMMANDS[@]}; do
    echo "%sudo ALL=(ALL) NOPASSWD:SETENV: ${SUDO_COMMAND}" >> /etc/sudoers.d/movai
done
