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
# File: deploy.sh
set -e

if [ -f ${APP_PATH}/requirements.txt ]; then
    printf "Installing python dependencies...\n"
    pushd ${APP_PATH} > /dev/null
    python3 -m pip install pip --user --upgrade
    python3 -m pip install --user --no-cache-dir -r requirements.txt
    popd > /dev/null
fi
