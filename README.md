[![main](https://github.com/MOV-AI/containers-movai-base/actions/workflows/docker-ci.yml/badge.svg?branch=main)](https://github.com/MOV-AI/containers-movai-base/actions/workflows/docker-ci.yml)

# docker-movai-base

Base Docker image of MOV.AI Framework

Image is built in 6 active flavours:

| Flavour      | Base Image | Python |
| ------------ | ---------- | ------ |
| movai-base-noetic | ros:noetic-robot | 3.8.10 |
| movai-base-focal | ubuntu:20.04 | 3.8.10 |
| movai-base-focal-python310 | ubuntu:20.04 | 3.10.19(default) & 3.8.10 |
| movai-base-humble | ros:humble-ros-base | 3.10 |
| movai-base-humble-python38 | ros:humble-ros-base | 3.10(default) & 3.8.10 |
| movai-base-jammy | ubuntu:22.04 | 3.10 |
| movai-base-jammy-python38 | ubuntu:22.04 | 3.10(default) & 3.8.10 |

## Deprecated Flavours

⚠️ **These flavours are deprecated and will be removed in a future release. Please migrate to supported alternatives.**

| Flavour      | Base Image | Python | Migration Path |
| ------------ | ---------- | ------ | -------------- |
| movai-base-melodic | ros:melodic-robot | 3.6.9 | Use `movai-base-noetic` |
| movai-base-bionic | ubuntu:18.04 | 3.6.9 | Use `movai-base-focal` |

Build and test functionality is maintained for deprecated flavours, but they are excluded from CI/CD and documentation.

## Building Images

Build and run shortcuts are available via the `Makefile`. Run `make help` to see all available commands.

Examples:

    make build-noetic
    make run-noetic

    make build-humble
    make run-humble

**Notes**:
- Multi-stage Dockerfiles are provided to build the images, make sure to select the right target.

- Mutli-arch builds are supported via `buildx`. Make sure to have it set up properly before building for multiple architectures.

## Features

- The images create a user `movai` with UID and GID 1000, so it's recommended to run the containers with `-u movai` to avoid permission issues.

- The images come with `sudo` installed and the `movai` user is part of the `sudo` group without password prompt.

- The images come with some handy scripts which can be launched on startup if some ENV variables are defined:
    - APT_AUTOINSTALL : if set to 'once', the autoinstall will only run once, any other value runs it systematically
    - APT_KEYS_URL_LIST : comma separated list of URLs to be piped into `apt-key add`
    - APT_REPOS_LIST : comma separated list of ppa to be given to `add-apt-repository`
    - APT_INSTALL_LIST : comma separated lsit of packages to be installed via APT

Examples :

    docker run --name base -d -u movai -e APT_AUTOINSTALL=once -e APT_KEYS_URL_LIST="https://download.docker.com/linux/ubuntu/gpg,https://apt.releases.hashicorp.com/gpg" -e APT_REPOS_LIST='deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable,deb [arch=amd64] https://apt.releases.hashicorp.com focal main' -e APT_INSTALL_LIST='docker-ce,terraform' movai-base:noetic

    docker run --name base -d -u movai -e APT_AUTOINSTALL=once -e APT_KEYS_URL_LIST="https://download.docker.com/linux/ubuntu/gpg,https://apt.releases.hashicorp.com/gpg" -e APT_REPOS_LIST='deb [arch=amd64] https://download.docker.com/linux/ubuntu jammy stable,deb [arch=amd64] https://apt.releases.hashicorp.com jammy main' -e APT_INSTALL_LIST='docker-ce,terraform' movai-base:humble

    docker run --name base -d -u movai -e APT_AUTOINSTALL=once -e APT_KEYS_URL_LIST="https://download.docker.com/linux/ubuntu/gpg,https://apt.releases.hashicorp.com/gpg" -e APT_REPOS_LIST='deb [arch=amd64] https://download.docker.com/linux/ubuntu jammy stable,deb [arch=amd64] https://apt.releases.hashicorp.com jammy main' -e APT_INSTALL_LIST='docker-ce,terraform' movai-base:humble-python38


## Testing Images

MOV.AI base images can be tested using [container-structure-test](https://github.com/GoogleContainerTools/container-structure-test) from GoogleContainerTools. This tool allows you to declaratively verify image contents, file existence, and command outputs.

### Install container-structure-test

You can install the binary directly:

```bash
sudo wget https://github.com/GoogleContainerTools/container-structure-test/releases/latest/download/container-structure-test-linux-amd64 -O /usr/local/bin/container-structure-test
sudo chmod +x /usr/local/bin/container-structure-test
```

Or run it via Docker (no install required):

```bash
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v "$PWD/tests:/tests" gcr.io/gcp-runtimes/container-structure-test test --image <image> --config /tests/<test-config>.yaml
```

### Run tests

After building an image, run the corresponding test:

```bash
container-structure-test test --image movai-base:noetic --config tests/test-noetic.yaml
container-structure-test test --image movai-base:humble --config tests/test-humble.yaml
```

Or use the Makefile:

```bash
make test-noetic
make test-humble
```

Test configs are located in the `tests/` directory and can be extended for other flavors.

## License
https://www.mov.ai/flow-license/
