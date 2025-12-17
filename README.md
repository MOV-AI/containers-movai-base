[![main](https://github.com/MOV-AI/containers-movai-base/actions/workflows/docker-ci.yml/badge.svg?branch=main)](https://github.com/MOV-AI/containers-movai-base/actions/workflows/docker-ci.yml)

# docker-movai-base

Base Docker image of MOV.AI Framework

Image is built in 4 flavours:

| Flavour      | Base Image | Python |
| ------------ | ---------- | ------ |
| movai-base-melodic | ros:melodic-robot | 3.6.9 |
| movai-base-noetic | ros:noetic-robot | 3.8.10 |
| movai-base-bionic | ubuntu:18.04 | 3.6.9 |
| movai-base-focal | ubuntu:20.04 | 3.8.10 |
| movai-base-focal-python310 | ubuntu:20.04 | 3.10.19 |

## Usage

The images come with some handy scripts which can be launched on startup if some ENV variables are defined:
- APT_AUTOINSTALL : if set to 'once', the autoinstall will only run once, any other value runs it systematically
- APT_KEYS_URL_LIST : comma separated list of URLs to be piped into `apt-key add`
- APT_REPOS_LIST : comma separated list of ppa to be given to `add-apt-repository`
- APT_INSTALL_LIST : comma separated lsit of packages to be installed via APT

Examples :

    docker run --name base -u movai -e APT_AUTOINSTALL=once -e APT_KEYS_URL_LIST="https://download.docker.com/linux/ubuntu/gpg,https://apt.releases.hashicorp.com/gpg" -e APT_REPOS_LIST='deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable,deb [arch=amd64] https://apt.releases.hashicorp.com bionic main' -e APT_INSTALL_LIST='docker-ce,terraform' movai-base:melodic

    docker run --name base -d -u movai -e APT_AUTOINSTALL=once -e APT_KEYS_URL_LIST="https://download.docker.com/linux/ubuntu/gpg,https://apt.releases.hashicorp.com/gpg" -e APT_REPOS_LIST='deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable,deb [arch=amd64] https://apt.releases.hashicorp.com focal main' -e APT_INSTALL_LIST='docker-ce,terraform' movai-base:noetic

## Build
**Note**: Multi-stage Dockerfiles are provided to build the images, make sure to select the right target.


Build MOVAI image based on ROS noetic :

    docker build -t movai-base:noetic -f docker/noetic/Dockerfile .

Build MOVAI image based on Ubuntu 18.04 :

    docker build -t movai-base:bionic -f docker/melodic/Dockerfile-rosfree .

Build MOVAI image based on Ubuntu 20.04 :

    docker build -t movai-base:focal --target base -f docker/noetic/Dockerfile-rosfree .

Build MOVAI image based on Ubuntu 20.04 with Python 3.10 :

    docker build -t movai-base:focal-python310 --target rosfree-python310 -f docker/noetic/Dockerfile-rosfree .

## Build for multi-arch

    docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
    docker buildx create --name multiarch --driver docker-container --use
    docker buildx inspect --bootstrap

    DOCKER_PLATFORMS=linux/amd64,linux/armhf,linux/arm64
    docker buildx build --pull --platform $DOCKER_PLATFORMS -t movai-base:noetic -f docker/noetic/Dockerfile .

    docker buildx build --push --pull --platform $DOCKER_PLATFORMS -t registry.aws.cloud.mov.ai/devops/multiarch-movai-base-noetic -f noetic/Dockerfile .

## License
https://www.mov.ai/flow-license/
