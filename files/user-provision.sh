#!/bin/bash
#
# Copyright 2021 MOV.AI (devops@mov.ai)
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
#
# File: user-provision.sh
set -e

USER_RC=/tmp/user.rc

# Load user configuration

[ -f ${USER_RC} ] || exit 0

source ${USER_RC}

if [ ! -z ${USER_FOLDERS} ]; then
    # Create folders
    for USER_FOLDER in "${USER_FOLDERS[@]}"; do
        mkdir -p ${USER_FOLDER}
        chown movai:movai ${USER_FOLDER}
    done
fi

if [ ! -z ${SYSTEM_FOLDERS} ]; then
    # Create folders
    for SYSTEM_FOLDER in "${SYSTEM_FOLDERS[@]}"; do
        mkdir -p ${SYSTEM_FOLDER}
    done
fi

if [ ! -z ${VARIABLES} ]; then
    # Store variables
    [ -f ${MOVAI_HOME}/movai.bash ] || touch ${MOVAI_HOME}/movai.bash
    chown -R movai:movai ${MOVAI_HOME}/movai.bash
    for VARIABLE in "${VARIABLES[@]}"; do
        printf "export %s=%s\n" "${VARIABLE}" "${!VARIABLE}" >> ${MOVAI_HOME}/movai.bash
    done
fi

# Clean up
rm --preserve-root ${USER_RC}
