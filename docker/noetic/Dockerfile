# This Dockerfile is the base image for Mov.ai - Based on ROS NOETIC
FROM ros:noetic-ros-base

# Labels
LABEL description="MOV.AI Base Image"
LABEL maintainer="devops@mov.ai"

# Arguments
ARG USER_ID=1000
ARG ROS_VERSION="noetic"
ARG HEALTH_NODE_URL="http://health-node:8081"
ARG APT_REPOSITORY="https://artifacts.aws.cloud.mov.ai/repository"

### Environment config
ENV MOVAI_HOME="/opt/mov.ai" \
    ROS_VERSION="$ROS_VERSION"
ENV APP_PATH="${MOVAI_HOME}/app" \
    APP_LOGS="${MOVAI_HOME}/logs" \
    APP_UPDATES="${MOVAI_HOME}/updates" \
    LOG_HTTP_HOST="${HEALTH_NODE_URL}" \
    USER_ID=${USER_ID}

# Create Default User and copy default settings
RUN adduser --uid ${USER_ID} --home ${MOVAI_HOME} --disabled-password --gecos '' movai

COPY --chown=movai:movai files/bashrc.bash ${MOVAI_HOME}/.bashrc
COPY --chown=movai:movai files/welcome ${MOVAI_HOME}/.welcome

# Copy build scripts
COPY files/user-provision.sh /usr/local/bin/
COPY files/install-packages.sh /usr/local/bin/
COPY --chown=movai:movai files/deploy.sh /usr/local/bin/deploy.sh

# Copy startup files
COPY files/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
COPY files/movai-entrypoint.sh /usr/local/bin/movai-entrypoint.sh

# Install base packages
COPY files/packages.bash /tmp/packages.bash
COPY docker/$ROS_VERSION/packages.apt /tmp/packages.apt

# Install requirements for ppa certificates registration
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections &&\
    apt-get update &&\
    apt-get install -y curl gnupg ca-certificates --no-install-recommends &&\
    apt-get upgrade -y &&\
    apt-get autoremove -y &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/* &&\
    rm -rf /var/log/*

COPY files/apt/movai-ubuntu-archive-proxy.list /etc/apt/sources.list.d/movai-ubuntu-archive-proxy.list
COPY files/apt/movai-ubuntu-ports-proxy.list /etc/apt/sources.list.d/movai-ubuntu-ports-proxy.list
COPY files/apt/movai-ubuntu-security-proxy.list /etc/apt/sources.list.d/movai-ubuntu-security-proxy.list
COPY files/apt/movai-ros-proxy.list /etc/apt/sources.list.d/movai-ros-proxy.list

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN find /etc/apt/sources.list.d/ -type f -name 'ros*.list' -exec rm {} \; &&\
    curl -fsSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key | gpg --dearmor -o /usr/share/keyrings/ros.key &&\
    apt-key add /usr/share/keyrings/ros.key &&\
    mv /etc/apt/sources.list /etc/apt/sources.list.bck &&\
    touch /etc/apt/sources.list &&\
    curl -fsSL $APT_REPOSITORY/movai-applications/gpg | apt-key add -  &&\
    #if [ "$(uname -m)" != "x86_64" ] ; then\
    # Remove irrelevant source lists based on architecture
    #rm /etc/apt/sources.list.d/movai-ubuntu-ports-proxy.list &&\
    #rm /etc/apt/sources.list.d/movai-ubuntu-archive* &&\
    #rm /etc/apt/sources.list.d/movai-ubuntu-security* ;\
    #redis-tools is not available for arm architectures
    #sed -i '/redis-tools/d' /tmp/packages.apt ;\
    #fi &&\
    apt-get update &&\
    /usr/local/bin/install-packages.sh &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/* &&\
    rm -rf /var/log/*

# Run user provision
COPY files/user.rc /tmp/user.rc
RUN /usr/local/bin/user-provision.sh

SHELL ["/bin/bash", "-c"]
WORKDIR ${APP_PATH}
ENTRYPOINT [ "docker-entrypoint.sh" ]
