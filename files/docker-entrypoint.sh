#!/bin/bash
#
# Copyright 2021 MOV.AI
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
# File: docker-entrypoint.sh
set -e

# Create link to allow other applications to print to docker stdout
ln -sf /proc/1/fd/1 "${APP_LOGS}"/stdout

[ -f "${MOVAI_HOME}"/.welcome ] && cat "${MOVAI_HOME}"/.welcome

# If we have updates on our update folder we do the update
if ls "${APP_UPDATES}"/movai-*_latest_*.deb 2>/dev/null; then
    # Run the update procedure and exit if everything goes well
    update.sh && exit
fi

# If we have apt keys to add
if [ -n "${APT_KEYS_URL_LIST}" ]; then
    for key_url in ${APT_KEYS_URL_LIST//,/ }; do
        printf "APT Key add: %s\n" "${key_url}"
        curl -fsSL "${key_url}" | sudo apt-key add -
    done
fi

# Switching separator to comma
SAVEIFS=$IFS
IFS=,

# If we have apt repos to add
if [ -n "${APT_REPOS_LIST}" ]; then
    for ppa in ${APT_REPOS_LIST}; do
        printf "APT Repo add: %s\n" "${ppa}"
        if sudo add-apt-repository -y "${ppa}" > /dev/null 2>&1; then
            printf "OK\n"
        else
            printf "FAILED\n"
        fi
    done
fi

# If we have packages on our env var we do install
if [ -n "${APT_INSTALL_LIST}" ]; then
    printf "APT Install list: %s\n" "${APT_INSTALL_LIST}"
    sudo apt-get update
    DEBIAN_FRONTEND=noninteractive sudo apt-get --quiet -y --no-install-recommends install ${APT_INSTALL_LIST}
    sudo apt-get clean -y
fi

# Switching back separator to default
IFS=$SAVEIFS

# Run command
exec /usr/local/bin/movai-entrypoint.sh ${@}
