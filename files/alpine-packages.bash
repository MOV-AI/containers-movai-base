#!/bin/bash
#
# Copyright 2026 MOV.AI
#
#    Licensed under the Mov.AI License version 1.0;
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#        https://www.mov.ai/flow-license/
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
#
# File: packages.bash

SUDO_COMMANDS=(
    /usr/bin/apk
)

# Setup available sudo commands for user movai
adduser movai sudo
mkdir -p /etc/sudoers.d
touch /etc/sudoers.d/movai
for SUDO_COMMAND in ${SUDO_COMMANDS[@]}; do
    echo "%sudo ALL=(ALL) NOPASSWD:SETENV: ${SUDO_COMMAND}" >> /etc/sudoers.d/movai
done
