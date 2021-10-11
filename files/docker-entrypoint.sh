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
# File: docker-entrypoint.sh
set -e

# Create link to allow other applications to print to docker stdout
ln -sf /proc/1/fd/1 ${APP_LOGS}/stdout

[ -f ${MOVAI_HOME}/.welcome ] && cat ${MOVAI_HOME}/.welcome

# Code from https://stackoverflow.com/questions/4023830/how-to-compare-two-strings-in-dot-separated-version-format-in-bash

function compare_version() {

    if [ "${1}" == "${2}" ]; then
        return 0
    fi

    local IFS=.
    local i ver1=(${1}) ver2=(${2})
    # fill empty fields in ver1 with zeros
    for ((i = ${#ver1[@]}; i < ${#ver2[@]}; i++)); do
        ver1[i]=0
    done

    for ((i = 0; i < ${#ver1[@]}; i++)); do
        if [[ -z ${ver2[i]} ]]; then
            # fill empty fields in ver2 with zeros
            ver2[i]=0
        fi
        if ((10#${ver1[i]} > 10#${ver2[i]})); then
            return 1
        fi
        if ((10#${ver1[i]} < 10#${ver2[i]})); then
            return 2
        fi
    done

    return 0
}

# If we have updates on our update folder we do the update
if [ $(ls ${APP_UPDATES}/movai-*_latest_*.deb 2>/dev/null) ]; then
    # Run the update procedure and exit if everything goes well
    update.sh && exit
fi

# Run command
exec /usr/local/bin/movai-entrypoint.sh ${@}
