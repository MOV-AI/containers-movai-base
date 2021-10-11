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
# File: install-packages.sh
set -eo pipefail

# Install apt dependencies

PACKAGE_FILE=/tmp/packages.apt

# If there is a package definition file, install packages then clean up
if [ -f ${PACKAGE_FILE} ]; then
    printf "Installing APT packages from list: %s ...\n" "$(basename ${PACKAGE_FILE})"
    packages_list=$(sed -e 's/#.*$//' -e '/^$/d' ${PACKAGE_FILE}| sed ':a;N;$!ba;s/\n/ /g')

    printf "APT Packages list: %s\n" "${packages_list}"
    apt-get update
    DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install ${packages_list}
    apt-get clean -y
    rm --preserve-root ${PACKAGE_FILE}
    rm -rf /var/cache/apt/*
    rm -rf /var/lib/apt/lists/*
fi

# Install custom dependencies and commands

PIP_REQUIREMENTS=/tmp/requirements.txt

# If there is a python requirements script, install packages then clean up
[ -f ${PIP_REQUIREMENTS} ] && {
    python3 -m pip install --upgrade pip;
    python3 -m pip install --upgrade -r ${PIP_REQUIREMENTS};
    rm --preserve-root ${PIP_REQUIREMENTS};
}

PACKAGES_SCRIPT=/tmp/packages.bash

# If there is a package script, install packages then clean up
[ -f ${PACKAGES_SCRIPT} ] && { chmod 700 ${PACKAGES_SCRIPT}; ${PACKAGES_SCRIPT}; rm --preserve-root ${PACKAGES_SCRIPT}; }


printf "Cleaning up ...\n"
rm -rf /tmp/*
