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
# File: docker-entrypoint.sh
set -e

# Create link to allow other applications to print to docker stdout
mkdir -p "${APP_LOGS}"
ln -sf /proc/1/fd/1 "${APP_LOGS}"/stdout

[ -f "${MOVAI_HOME}"/.welcome ] && cat "${MOVAI_HOME}"/.welcome


# Run command
exec /usr/local/bin/movai-entrypoint.sh ${@}
