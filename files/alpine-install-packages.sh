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
# File: install-packages.sh
set -eo pipefail

# Install apk dependencies
PACKAGE_FILE=/tmp/packages.apk


# If there is a package definition file, install packages then clean up
if [ -f ${PACKAGE_FILE} ]; then
    printf "Installing APK packages from list: %s ...\n" "$(basename ${PACKAGE_FILE})"
    packages_list=$(sed -e 's/#.*$//' -e '/^$/d' ${PACKAGE_FILE}| sed ':a;N;$!ba;s/\n/ /g')

    printf "APK Packages list: %s\n" "${packages_list}"
    apk update
    apk add --no-cache ${packages_list}
    rm -f -- ${PACKAGE_FILE}
fi

# Install custom dependencies and commands
PIP_REQUIREMENTS=/tmp/requirements.txt

# If there is a python requirements script, install packages then clean up
[ -f ${PIP_REQUIREMENTS} ] && {
    python3 -m pip install --upgrade pip;
    python3 -m pip install --upgrade -r ${PIP_REQUIREMENTS};
    rm -f -- ${PIP_REQUIREMENTS};
}

printf "Cleaning up ...\n"
rm -rf /tmp/*
printf "Done.\n"
