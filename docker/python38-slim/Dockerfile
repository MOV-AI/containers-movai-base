# This Dockerfile is the base image for Mov.ai - Based on Debian Bookworm Python 3.8
FROM python:3.8-slim AS base

# Labels
LABEL description="MOV.AI Base Image"
LABEL maintainer="devops@mov.ai"

# Arguments
ARG USER_ID=1000

### Environment config
ENV MOVAI_HOME="/opt/mov.ai"
ENV APP_PATH="${MOVAI_HOME}/app" \
    APP_LOGS="${MOVAI_HOME}/logs" \
    APP_UPDATES="${MOVAI_HOME}/updates" \
    USER_ID=${USER_ID}

# Create Default User and copy default settings
RUN adduser --uid ${USER_ID} --home ${MOVAI_HOME} --disabled-password --gecos '' movai

COPY --chown=movai:movai files/bashrc.bash ${MOVAI_HOME}/.bashrc
COPY --chown=movai:movai files/welcome ${MOVAI_HOME}/.welcome

# Copy build scripts
COPY files/user-provision.sh /usr/local/bin/user-provision.sh

# Copy startup files
COPY files/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
COPY files/movai-entrypoint.sh /usr/local/bin/movai-entrypoint.sh

# Install base packages
COPY files/packages.bash /tmp/packages.bash
COPY files/install-packages.sh /usr/local/bin/install-packages.sh
COPY docker/python38-slim/packages.apt /tmp/packages.apt

# switching pypi index capability
COPY files/setup-pypi-env.sh /usr/local/bin/setup-pypi-env.sh
COPY resources /usr/local/share/pypi-confs/resources

RUN /usr/local/bin/install-packages.sh

# Run user provision
COPY files/user.rc /tmp/user.rc
RUN /usr/local/bin/user-provision.sh

SHELL ["/bin/bash", "-c"]
WORKDIR ${APP_PATH}
ENTRYPOINT [ "docker-entrypoint.sh" ]
