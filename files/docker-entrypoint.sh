#!/bin/bash
#
# Copyright 2021 MOV.AI
#
#    Licensed under the Mov.AI License version 1.0;
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#        https://flow.mov.ai/licenses/LICENSE-1.0
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

# If we have updates on our update folder we do the update
if [ $(ls ${APP_UPDATES}/movai-*_latest_*.deb 2>/dev/null) ]; then
    # Run the update procedure and exit if everything goes well
    update.sh && exit
fi

# If we have packages on our env var we do install
if [ -z "${APT_INSTALL_LIST}" ]; then
    printf "APT Install list: %s\n" "${APT_INSTALL_LIST}"
    apt-get update
    DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install ${APT_INSTALL_LIST}
    apt-get clean -y
fi

# Run command
exec /usr/local/bin/movai-entrypoint.sh ${@}
