# This Dockerfile is the base image for Mov.ai - Based on ROS NOETIC
FROM ros:noetic-ros-base

# Labels
LABEL description="MOV.AI Base Image"
LABEL maintainer="devops@mov.ai"

# Arguments
ARG USER_ID=1000
ARG ROS_VERSION="noetic"
ARG HEALTH_NODE_URL="http://health-node:8081"

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
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN find /etc/apt/sources.list.d/ -type f -name 'ros*.list' -exec rm {} \; &&\
    echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections &&\
    apt-get update && apt-get upgrade -y && apt-get install -y curl --no-install-recommends &&\
    curl -fsSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key | gpg --dearmor -o /usr/share/keyrings/ros.key &&\
    #echo /usr/share/ubuntu-archive-keyring.gpg | gpg --dearmor -o /usr/share/keyrings/ubuntu-archive.key && \
    echo "deb [signed-by=/usr/share/keyrings/ros.key] https://artifacts.aws.cloud.mov.ai/repository/ppa-proxy-ros focal main" | tee /etc/apt/sources.list.d/movai-ros.list > /dev/null &&\
    sed -e 's#deb http://archive#\#deb http://archive#g' -i /etc/apt/sources.list &&\
    sed -e 's#deb http://security#\#deb http://security#g' -i /etc/apt/sources.list &&\
    # Add focal proxy
    echo "deb https://artifacts.aws.cloud.mov.ai/repository/ppa-archive-focal focal universe" >> /etc/apt/sources.list.d/movai-ubuntu-archive-proxy.list &&\
    echo "deb https://artifacts.aws.cloud.mov.ai/repository/ppa-archive-focal focal multiverse" >> /etc/apt/sources.list.d/movai-ubuntu-archive-proxy.list &&\
    echo "deb https://artifacts.aws.cloud.mov.ai/repository/ppa-archive-focal focal main" >> /etc/apt/sources.list.d/movai-ubuntu-archive-proxy.list &&\
    echo "deb https://artifacts.aws.cloud.mov.ai/repository/ppa-archive-focal focal restricted" >> /etc/apt/sources.list.d/movai-ubuntu-archive-proxy.list &&\
    # Add focal-updates proxy
    echo "deb https://artifacts.aws.cloud.mov.ai/repository/ppa-archive-focal-updates focal-updates universe" >> /etc/apt/sources.list.d/movai-ubuntu-archive-proxy.list &&\
    echo "deb https://artifacts.aws.cloud.mov.ai/repository/ppa-archive-focal-updates focal-updates multiverse" >> /etc/apt/sources.list.d/movai-ubuntu-archive-proxy.list &&\
    echo "deb https://artifacts.aws.cloud.mov.ai/repository/ppa-archive-focal-updates focal-updates main" >> /etc/apt/sources.list.d/movai-ubuntu-archive-proxy.list &&\
    echo "deb https://artifacts.aws.cloud.mov.ai/repository/ppa-archive-focal-updates focal-updates restricted" >> /etc/apt/sources.list.d/movai-ubuntu-archive-proxy.list &&\
    # Add focal-backports proxy
    echo "deb https://artifacts.aws.cloud.mov.ai/repository/ppa-archive-focal-backports focal-backports universe" >> /etc/apt/sources.list.d/movai-ubuntu-archive-proxy.list &&\
    echo "deb https://artifacts.aws.cloud.mov.ai/repository/ppa-archive-focal-backports focal-backports multiverse" >> /etc/apt/sources.list.d/movai-ubuntu-archive-proxy.list &&\
    echo "deb https://artifacts.aws.cloud.mov.ai/repository/ppa-archive-focal-backports focal-backports main" >> /etc/apt/sources.list.d/movai-ubuntu-archive-proxy.list &&\
    # Add focal security proxy
    echo "deb https://artifacts.aws.cloud.mov.ai/repository/ppa-security-focal focal-security main restricted" >> /etc/apt/sources.list.d/movai-ubuntu-security-proxy.list &&\
    echo "deb https://artifacts.aws.cloud.mov.ai/repository/ppa-security-focal focal-security universe" >> /etc/apt/sources.list.d/movai-ubuntu-security-proxy.list &&\
    echo "deb https://artifacts.aws.cloud.mov.ai/repository/ppa-security-focal focal-security multiverse" >> /etc/apt/sources.list.d/movai-ubuntu-security-proxy.list &&\
    sudo apt update &&\
    /usr/local/bin/install-packages.sh &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/* &&\
    rm -rf /var/log/*

# # Run user provision
COPY files/user.rc /tmp/user.rc
RUN /usr/local/bin/user-provision.sh

SHELL ["/bin/bash", "-c"]
WORKDIR ${APP_PATH}
ENTRYPOINT [ "docker-entrypoint.sh" ]
