# This Dockerfile is the base image for Mov.ai - Based on ROS NOETIC
FROM ros:noetic-robot

# Labels
LABEL description="MOV.AI Base Image"
LABEL maintainer="devops@mov.ai"

# Arguments
ARG USER_ID=1000
ARG ROS_GPG_KEY=C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
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
COPY $ROS_VERSION/packages.apt /tmp/packages.apt

COPY files/apt/movai-ubuntu-archive-proxy.list /etc/apt/sources.list.d/movai-ubuntu-archive-proxy.list
COPY files/apt/movai-ubuntu-ports-proxy.list /etc/apt/sources.list.d/movai-ubuntu-ports-proxy.list
COPY files/apt/movai-ubuntu-security-proxy.list /etc/apt/sources.list.d/movai-ubuntu-security-proxy.list

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN find /etc/apt/sources.list.d/ -type f -name 'ros*.list' -exec rm {} \; &&\
    #apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key "${ROS_GPG_KEY}" &&\
    echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections &&\
    apt-get update && apt-get upgrade -y && apt-get install -y curl --no-install-recommends &&\
    curl -fsSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key | gpg --dearmor -o /usr/share/keyrings/ros.key &&\
    echo "deb [signed-by=/usr/share/keyrings/ros.key] https://artifacts.aws.cloud.mov.ai/repository/ppa-proxy-ros focal main" | tee /etc/apt/sources.list.d/movai-ros.list > /dev/null &&\
    mv /etc/apt/sources.list /etc/apt/sources.list.bck &&\
    touch /etc/apt/sources.list &&\
    curl -fsSL $APT_REPOSITORY/movai-applications/gpg | apt-key add -  &&\
    if [ "$(uname -m)" = "x86_64" ] ; then rm /etc/apt/sources.list.d/movai-ubuntu-ports-proxy.list ; fi &&\ 
    if [ "$(uname -m)" = "aarch64" ] || [ "$(uname -m)" = "armv7l" ] ; then rm /etc/apt/sources.list.d/movai-ubuntu-archive* && rm /etc/apt/sources.list.d/movai-ubuntu-security* ; fi &&\ 
    apt-get update && apt-get upgrade -y &&\
    /usr/local/bin/install-packages.sh &&\
    # Clean apt
    apt-get autoremove -y && \
    apt-get clean -y > /dev/null && \
    # Clean pip temp files
    /usr/bin/python3 -m pip install pyclean && \
    # Remove __pycache__ folders
    /usr/bin/python3 -m pyclean /usr/ /opt/ && \
    # Remove apt cache and tmp files
    python3 -c "import glob, shutil, os; \
[shutil.rmtree(d) for pattern in ['/var/lib/apt/lists/*', '/tmp/*', '/var/cache/apt/*'] \
    for d in glob.glob(pattern) if os.path.isdir(d)]" && \
    rm -rf /var/lib/apt/lists/* &&\
    rm -rf /var/log/*

# Run user provision
COPY files/user.rc /tmp/user.rc
RUN /usr/local/bin/user-provision.sh

SHELL ["/bin/bash", "-c"]
WORKDIR ${APP_PATH}
ENTRYPOINT [ "docker-entrypoint.sh" ]
