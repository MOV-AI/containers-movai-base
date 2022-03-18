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

## Usage

The images come with some handy scripts which can be launched on startup if some ENV variables are defined:

- APT_KEYS_URL_LIST : comma separated list of URLs to be piped into `apt-key add`
- APT_REPOS_LIST : comma separated list of ppa to be given to `add-apt-repository`
- APT_INSTALL_LIST : comma separated lsit of packages to be installed via APT

Example :

    docker run --rm -u movai -e APT_KEYS_URL_LIST="https://download.docker.com/linux/ubuntu/gpg,https://apt.releases.hashicorp.com/gpg" -e APT_REPOS_LIST='deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable,deb [arch=amd64] https://apt.releases.hashicorp.com bionic main' -e APT_INSTALL_LIST='docker-ce,terraform' movai-base:melodic

## Build

Build MOVAI image based on ROS melodic :

    docker build -t movai-base:melodic -f melodic/Dockerfile .

Build MOVAI image based on ROS noetic :

    docker build -t movai-base:noetic -f noetic/Dockerfile .

Build MOVAI image based on Ubuntu 18.04 :

    docker build -t movai-base:bionic -f melodic/Dockerfile-rosfree .

Build MOVAI image based on Ubuntu 20.04 :

    docker build -t movai-base:focal -f noetic/Dockerfile-rosfree .

## License
https://www.mov.ai/flow-license/
