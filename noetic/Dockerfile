# This Dockerfile is the base image for Mov.ai - Based on ROS NOETIC
FROM ros:noetic-robot

# Labels
LABEL description="MOV.AI Base Image"
LABEL maintainer="devops@mov.ai"

# Arguments
ARG USER_ID=1000
ARG ROS_GPG_KEY=C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
ARG ROS_VERSION="noetic"

### Environment config
ENV MOVAI_HOME="/opt/mov.ai" \
    ROS_VERSION="$ROS_VERSION"
ENV APP_PATH="${MOVAI_HOME}/app" \
    APP_LOGS="${MOVAI_HOME}/logs" \
    APP_UPDATES="${MOVAI_HOME}/updates" \
    LOG_HTTP_HOST="http://health-node:8081" \
    USER_ID=${USER_ID}

# Create Default User and copy default settings
RUN adduser --uid ${USER_ID} --home ${MOVAI_HOME} --disabled-password --gecos '' movai && \
    apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key "${ROS_GPG_KEY}" && \
    apt-get update && apt-get upgrade -y &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/*

COPY --chown=movai:movai files/bashrc.bash ${MOVAI_HOME}/.bashrc
COPY --chown=movai:movai files/welcome ${MOVAI_HOME}/.welcome

# Copy build scripts
COPY files/user-provision.sh /usr/local/bin/
COPY files/install-packages.sh /usr/local/bin/
COPY --chown=movai:movai files/deploy.sh /usr/local/bin/deploy.sh
COPY --chown=movai:movai files/update.sh /usr/local/bin/update.sh

# Copy startup files
COPY files/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
COPY files/movai-entrypoint.sh /usr/local/bin/movai-entrypoint.sh

# Install base packages
COPY files/packages.bash /tmp/packages.bash
COPY $ROS_VERSION/packages.apt /tmp/packages.apt
RUN /usr/local/bin/install-packages.sh

# Run user provision
COPY files/user.rc /tmp/user.rc
RUN /usr/local/bin/user-provision.sh

SHELL ["/bin/bash", "-c"]
WORKDIR ${APP_PATH}
ENTRYPOINT [ "docker-entrypoint.sh" ]
