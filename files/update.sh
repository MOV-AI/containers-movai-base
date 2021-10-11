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
# File: update.sh
set -e

UPDATE_FILE=$(ls ${APP_UPDATES}/movai-*_latest_*.deb)

# If there is no version file we create one
[ ! -f ${MOVAI_HOME}/version ] && touch ${MOVAI_HOME}/version

# Get package version
VERSION_UPDATE=$(dpkg-deb -f ${UPDATE_FILE} Version)
VERSION_CURRENT=$(<${MOVAI_HOME}/version)
RETVAL=1

compare_version "${VERSION_CURRENT}" "${VERSION_UPDATE}"

# if the packaged version is greater then the one we have we
# do the installation
if [ ${?} -eq 2 ]; then

    printf "Starting updating to version: %s\n" "${VERSION_UPDATE}"

    # Create working directory
    WORKDIR=$(mktemp -d)
    pushd ${WORKDIR} >/dev/null

    # Unpack the firmware deb packages
    printf "Unpackaging firmware...\n"
    dpkg-deb -x ${UPDATE_FILE} ./

    # Check if we need pre installation actions
    if [ -f .${APP_PATH}/pre-installation.bash ]; then
        printf "Running pre installation actions!\n"
        pushd .${APP_PATH} >/dev/null
        bash pre-installation.bash
        rm pre-installation.bash
        popd >/dev/null
    fi

    # clean old application
    printf "Cleaning old firmware..\n"
    rm -rf ${APP_PATH}/*

    # move new update
    printf "Installing new firmware...\n"
    mv .${APP_PATH}/* ${APP_PATH}

    # update pip requeriments
    if [ -f ${APP_PATH}/requirements.txt ]; then
        printf "Installing python dependencies...\n"
        pushd ${APP_PATH} >/dev/null
        python3 -m pip install pip --user --upgrade
        python3 -m pip install --user --no-cache-dir -r requirements.txt
        popd >/dev/null
    fi

    # Check if we need post installation actions
    if [ -f ${APP_PATH}/post-installation.bash ]; then
        printf "Running post installation actions!\n"
        pushd ${APP_PATH} >/dev/null
        bash post-installation.bash
        rm post-installation.bash
        popd >/dev/null
    fi

    popd >/dev/null

    # store current version
    echo ${VERSION_UPDATE} > ${MOVAI_HOME}/version

    printf "Cleaning up resources...\n"
    rm -rf ${WORKDIR}

    # If update go well we return a 0 code
    RETVAL=0
fi

rm ${UPDATE_FILE}
exit ${RETVAL}