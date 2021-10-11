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

## About

## Usage

Build MOVAI image based on ROS melodic :

    docker build -t movai-base:melodic -f melodic/Dockerfile .

Build MOVAI image based on ROS noetic :

    docker build -t movai-base:noetic -f noetic/Dockerfile .

Build MOVAI image based on Ubuntu 18.04 :

    docker build -t movai-base:bionic -f melodic/Dockerfile-rosfree .

Build MOVAI image based on Ubuntu 20.04 :

    docker build -t movai-base:focal -f noetic/Dockerfile-rosfree .

