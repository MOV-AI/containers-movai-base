# Makefile for MOV.AI Base Docker Images
# Active flavors: noetic, focal, focal-python310, humble, humble-python38, jammy, jammy-python38
# Deprecated flavors: melodic, bionic

# Configuration
REGISTRY ?= movai-base
DOCKER_PLATFORMS ?= linux/amd64,linux/armhf,linux/arm64

# Active image tags
NOETIC_TAG = $(REGISTRY):noetic
FOCAL_TAG = $(REGISTRY):focal
FOCAL_PYTHON310_TAG = $(REGISTRY):focal-python310
HUMBLE_TAG = $(REGISTRY):humble
HUMBLE_PYTHON38_TAG = $(REGISTRY):humble-python38
JAMMY_TAG = $(REGISTRY):jammy
JAMMY_PYTHON38_TAG = $(REGISTRY):jammy-python38

# Deprecated image tags
MELODIC_TAG = $(REGISTRY):melodic
BIONIC_TAG = $(REGISTRY):bionic

# All image tags
ALL_TAGS = $(NOETIC_TAG) $(FOCAL_TAG) $(HUMBLE_TAG) $(HUMBLE_PYTHON38_TAG) $(JAMMY_TAG) $(JAMMY_PYTHON38_TAG) $(MELODIC_TAG) $(BIONIC_TAG)

.PHONY: help build build-all run test clean setup-multiarch
.PHONY: build-noetic build-focal build-focal-python310 build-humble build-humble-python38 build-jammy build-jammy-python38
.PHONY: run-noetic run-focal run-focal-python310 run-humble run-humble-python38 run-jammy run-jammy-python38
.PHONY: test-noetic test-focal test-focal-python310 test-humble test-humble-python38 test-jammy test-jammy-python38
.PHONY: build-melodic build-bionic run-melodic run-bionic test-melodic test-bionic
.PHONY: buildx-all push-all

# Default target
help:
	@echo "MOV.AI Base Docker Images Makefile"
	@echo ""
	@echo "Available targets:"
	@echo "  help                	- Show this help message"
	@echo ""
	@echo "Active Build targets:"
	@echo "  build-all           	- Build all active image flavors"
	@echo "  build-noetic        	- Build noetic flavor (ROS Noetic)"
	@echo "  build-focal         	- Build focal flavor (Ubuntu 20.04)"
	@echo "  build-focal-python310 	- Build focal flavor with Python 3.10"
	@echo "  build-humble        	- Build humble flavor (ROS2 Humble)"
	@echo "  build-humble-python38 	- Build humble flavor with Python 3.8"
	@echo "  build-jammy         	- Build jammy flavor (Ubuntu 22.04)"
	@echo "  build-jammy-python38 	- Build jammy flavor with Python 3.8"
	@echo ""
	@echo "Deprecated Build targets (⚠️  not recommended):"
	@echo "  build-melodic       	- Build melodic flavor (ROS Melodic) - DEPRECATED"
	@echo "  build-bionic        	- Build bionic flavor (Ubuntu 18.04) - DEPRECATED"
	@echo ""
	@echo "Run targets:"
	@echo "  run-<flavor>        - Run interactive container for specific flavor"
	@echo ""
	@echo "Test targets:"
	@echo "  test-all            - Test all active image flavors"
	@echo "  test-<flavor>       - Test specific flavor with verification"
	@echo ""
	@echo "Multi-arch targets:"
	@echo "  setup-multiarch     - Setup Docker buildx for multi-arch builds"
	@echo "  buildx-all          - Build all flavors for multiple architectures"
	@echo "  push-all            - Build and push all flavors to registry"
	@echo ""
	@echo "Utility targets:"
	@echo "  clean               - Remove all built images"
	@echo ""
	@echo "Environment variables:"
	@echo "  REGISTRY            - Docker registry/image prefix (default: movai-base)"
	@echo "  DOCKER_PLATFORMS    - Target platforms for buildx (default: linux/amd64,linux/armhf,linux/arm64)"

# Active Build targets
build-all: build-noetic build-focal build-focal-python310 build-humble build-humble-python38 build-jammy build-jammy-python38
build-noetic:
	@echo "Building MOV.AI Base Noetic (ROS Noetic)..."
	docker build -t $(NOETIC_TAG) -f docker/noetic/Dockerfile .

build-focal:
	@echo "Building MOV.AI Base Focal (Ubuntu 20.04)..."
	docker build -t $(FOCAL_TAG) --target base -f docker/noetic/Dockerfile-rosfree .

build-focal-python310:
	@echo "Building MOV.AI Base Focal with Python 3.10..."
	docker build -t $(FOCAL_PYTHON310_TAG) --target rosfree-python310 -f docker/noetic/Dockerfile-rosfree .

build-humble:
	@echo "Building MOV.AI Base Humble (ROS2 Humble)..."
	docker build -t $(HUMBLE_TAG) -f docker/humble/Dockerfile .

build-humble-python38:
	@echo "Building MOV.AI Base Humble with Python 3.8..."
	docker build -t $(HUMBLE_PYTHON38_TAG) --target humble-python38 -f docker/humble/Dockerfile .

build-jammy:
	@echo "Building MOV.AI Base Jammy (Ubuntu 22.04)..."
	docker build -t $(JAMMY_TAG) --target base -f docker/humble/Dockerfile-rosfree .

build-jammy-python38:
	@echo "Building MOV.AI Base Jammy with Python 3.8..."
	docker build -t $(JAMMY_PYTHON38_TAG) --target jammy-python38 -f docker/humble/Dockerfile-rosfree .

# Deprecated Build targets (maintained for compatibility)
build-melodic:
	@echo "⚠️  WARNING: melodic flavor is DEPRECATED. Please migrate to 'noetic'."
	@echo "Building MOV.AI Base Melodic (ROS Melodic)..."
	docker build -t $(MELODIC_TAG) -f docker/melodic/Dockerfile-rosfree .

build-bionic:
	@echo "⚠️  WARNING: bionic flavor is DEPRECATED. Please migrate to 'focal'."
	@echo "Building MOV.AI Base Bionic (Ubuntu 18.04)..."
	docker build -t $(BIONIC_TAG) -f docker/melodic/Dockerfile-rosfree .

# Run targets - Start interactive containers
run-melodic: build-melodic
	@echo "Starting interactive melodic container..."
	docker run --rm -it --user movai $(MELODIC_TAG) bash

run-noetic: build-noetic
	@echo "Starting interactive noetic container..."
	docker run --rm -it --user movai $(NOETIC_TAG) bash

run-bionic: build-bionic
	@echo "Starting interactive bionic container..."
	docker run --rm -it --user movai $(BIONIC_TAG) bash

run-focal: build-focal
	@echo "Starting interactive focal container..."
	docker run --rm -it --user movai $(FOCAL_TAG) bash

run-focal-python310: build-focal-python310
	@echo "Starting interactive focal-python310 container..."
	docker run --rm -it --user movai $(FOCAL_PYTHON310_TAG) bash

run-humble: build-humble
	@echo "Starting interactive humble container..."
	docker run --rm -it --user movai $(HUMBLE_TAG) bash

run-jammy: build-jammy
	@echo "Starting interactive jammy container..."
	docker run --rm -it --user movai $(JAMMY_TAG) bash

run-humble-python38: build-humble-python38
	@echo "Starting interactive humble-python38 container..."
	docker run --rm -it --user movai $(HUMBLE_PYTHON38_TAG) bash

run-jammy-python38: build-jammy-python38
	@echo "Starting interactive jammy-python38 container..."
	docker run --rm -it --user movai $(JAMMY_PYTHON38_TAG) bash

# Test targets - Run verification tests (only active flavors)
test-all: test-noetic test-focal test-focal-python310 test-humble test-humble-python38 test-jammy test-jammy-python38

test-melodic: build-melodic
	@echo "Testing melodic image..."
	@docker run --rm $(MELODIC_TAG) python3 --version | grep -q "Python 3.6" || (echo "❌ Expected Python 3.6" && exit 1)
	@docker run --rm $(MELODIC_TAG) whoami | grep -q "root" || (echo "❌ Expected root user" && exit 1)
	@docker run --rm $(MELODIC_TAG) test -d /opt/mov.ai/app -a -d /opt/mov.ai/logs -a -d /opt/mov.ai/updates || (echo "❌ Missing MOV.AI directories" && exit 1)
	@docker run --rm $(MELODIC_TAG) lsb_release -r | grep -q "18.04" || (echo "❌ Expected Ubuntu 18.04" && exit 1)
	@echo "✓ Melodic tests passed"

test-noetic: build-noetic
	@echo "Testing noetic image..."
	@docker run --rm $(NOETIC_TAG) python3 --version | grep -q "Python 3.8" || (echo "❌ Expected Python 3.8" && exit 1)
	@docker run --rm $(NOETIC_TAG) whoami | grep -q "root" || (echo "❌ Expected root user" && exit 1)
	@docker run --rm $(NOETIC_TAG) test -d /opt/mov.ai/app -a -d /opt/mov.ai/logs -a -d /opt/mov.ai/updates || (echo "❌ Missing MOV.AI directories" && exit 1)
	@echo "✓ Noetic tests passed"

test-bionic: build-bionic
	@echo "Testing bionic image..."
	@docker run --rm $(BIONIC_TAG) python3 --version | grep -q "Python 3.6" || (echo "❌ Expected Python 3.6" && exit 1)
	@docker run --rm $(BIONIC_TAG) whoami | grep -q "root" || (echo "❌ Expected root user" && exit 1)
	@docker run --rm $(BIONIC_TAG) test -d /opt/mov.ai/app -a -d /opt/mov.ai/logs -a -d /opt/mov.ai/updates || (echo "❌ Missing MOV.AI directories" && exit 1)
	@docker run --rm $(BIONIC_TAG) lsb_release -r | grep -q "18.04" || (echo "❌ Expected Ubuntu 18.04" && exit 1)
	@echo "✓ Bionic tests passed"

test-focal: build-focal
	@echo "Testing focal image..."
	@docker run --rm $(FOCAL_TAG) python3 --version | grep -q "Python 3.8" || (echo "❌ Expected Python 3.8" && exit 1)
	@docker run --rm $(FOCAL_TAG) whoami | grep -q "root" || (echo "❌ Expected root user" && exit 1)
	@docker run --rm $(FOCAL_TAG) test -d /opt/mov.ai/app -a -d /opt/mov.ai/logs -a -d /opt/mov.ai/updates || (echo "❌ Missing MOV.AI directories" && exit 1)
	@docker run --rm $(FOCAL_TAG) lsb_release -r | grep -q "20.04" || (echo "❌ Expected Ubuntu 20.04" && exit 1)
	@echo "✓ Focal tests passed"

test-focal-python310: build-focal-python310
	@echo "Testing focal-python310 image..."
	@docker run --rm $(FOCAL_PYTHON310_TAG) python3 --version | grep -q "Python 3.10" || (echo "❌ Expected Python 3.10" && exit 1)
	@docker run --rm $(FOCAL_PYTHON310_TAG) whoami | grep -q "root" || (echo "❌ Expected root user" && exit 1)
	@docker run --rm $(FOCAL_PYTHON310_TAG) test -d /opt/mov.ai/app -a -d /opt/mov.ai/logs -a -d /opt/mov.ai/updates || (echo "❌ Missing MOV.AI directories" && exit 1)
	@docker run --rm $(FOCAL_PYTHON310_TAG) lsb_release -r | grep -q "20.04" || (echo "❌ Expected Ubuntu 20.04" && exit 1)
	@echo "✓ Focal Python 3.10 tests passed"

test-humble: build-humble
	@echo "Testing humble image..."
	@docker run --rm $(HUMBLE_TAG) python3 --version | grep -q "Python 3.10" || (echo "❌ Expected Python 3.10" && exit 1)
	@docker run --rm $(HUMBLE_TAG) whoami | grep -q "root" || (echo "❌ Expected root user" && exit 1)
	@docker run --rm $(HUMBLE_TAG) test -d /opt/mov.ai/app -a -d /opt/mov.ai/logs -a -d /opt/mov.ai/updates || (echo "❌ Missing MOV.AI directories" && exit 1)
	@docker run --rm $(HUMBLE_TAG) lsb_release -r | grep -q "22.04" || (echo "❌ Expected Ubuntu 22.04" && exit 1)
	@echo "✓ Humble tests passed"

test-jammy: build-jammy
	@echo "Testing jammy image..."
	@docker run --rm $(JAMMY_TAG) python3 --version | grep -q "Python 3.10" || (echo "❌ Expected Python 3.10" && exit 1)
	@docker run --rm $(JAMMY_TAG) whoami | grep -q "root" || (echo "❌ Expected root user" && exit 1)
	@docker run --rm $(JAMMY_TAG) test -d /opt/mov.ai/app -a -d /opt/mov.ai/logs -a -d /opt/mov.ai/updates || (echo "❌ Missing MOV.AI directories" && exit 1)
	@docker run --rm $(JAMMY_TAG) lsb_release -r | grep -q "22.04" || (echo "❌ Expected Ubuntu 22.04" && exit 1)
	@echo "✓ Jammy tests passed"

test-humble-python38: build-humble-python38
	@echo "Testing humble-python38 image..."
	@docker run --rm $(HUMBLE_PYTHON38_TAG) python3 --version | grep -q "Python 3.8" || (echo "❌ Expected Python 3.8" && exit 1)
	@docker run --rm $(HUMBLE_PYTHON38_TAG) whoami | grep -q "root" || (echo "❌ Expected root user" && exit 1)
	@docker run --rm $(HUMBLE_PYTHON38_TAG) test -d /opt/mov.ai/app -a -d /opt/mov.ai/logs -a -d /opt/mov.ai/updates || (echo "❌ Missing MOV.AI directories" && exit 1)
	@docker run --rm $(HUMBLE_PYTHON38_TAG) lsb_release -r | grep -q "22.04" || (echo "❌ Expected Ubuntu 22.04" && exit 1)
	@docker run --rm $(HUMBLE_PYTHON38_TAG) python3 -m pip --version | grep -q "pip" || (echo "❌ pip not available" && exit 1)
	@echo "✓ Humble Python 3.8 tests passed"

test-jammy-python38: build-jammy-python38
	@echo "Testing jammy-python38 image..."
	@docker run --rm $(JAMMY_PYTHON38_TAG) python3 --version | grep -q "Python 3.8" || (echo "❌ Expected Python 3.8" && exit 1)
	@docker run --rm $(JAMMY_PYTHON38_TAG) which python3 | grep -q "/usr/local/bin/python3.8" || (echo "❌ Python not in expected location" && exit 1)
	@docker run --rm $(JAMMY_PYTHON38_TAG) whoami | grep -q "movai" || (echo "❌ Expected movai user" && exit 1)
	@docker run --rm $(JAMMY_PYTHON38_TAG) test -d /opt/mov.ai/app -a -d /opt/mov.ai/logs -a -d /opt/mov.ai/updates || (echo "❌ Missing MOV.AI directories" && exit 1)
	@docker run --rm $(JAMMY_PYTHON38_TAG) lsb_release -r | grep -q "22.04" || (echo "❌ Expected Ubuntu 22.04" && exit 1)
	@docker run --rm $(JAMMY_PYTHON38_TAG) python3 -m pip --version | grep -q "pip" || (echo "❌ pip not available" && exit 1)
	@echo "✓ Jammy Python 3.8 tests passed"

# Multi-architecture build setup
setup-multiarch:
	@echo "Setting up Docker buildx for multi-architecture builds..."
	docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
	docker buildx create --name multiarch --driver docker-container --use || true
	docker buildx inspect --bootstrap

# Multi-architecture builds
buildx-all: setup-multiarch
	@echo "Building all flavors for multiple architectures..."
	docker buildx build --pull --platform $(DOCKER_PLATFORMS) -t $(NOETIC_TAG) -f docker/noetic/Dockerfile .
	docker buildx build --pull --platform $(DOCKER_PLATFORMS) -t $(FOCAL_TAG) --target base -f docker/noetic/Dockerfile-rosfree .
	docker buildx build --pull --platform $(DOCKER_PLATFORMS) -t $(FOCAL_PYTHON310_TAG) --target rosfree-python310 -f docker/noetic/Dockerfile-rosfree .
	docker buildx build --pull --platform $(DOCKER_PLATFORMS) -t $(HUMBLE_TAG) -f docker/humble/Dockerfile .
	docker buildx build --pull --platform $(DOCKER_PLATFORMS) -t $(HUMBLE_PYTHON38_TAG) --target humble-python38 -f docker/humble/Dockerfile .
	docker buildx build --pull --platform $(DOCKER_PLATFORMS) -t $(JAMMY_TAG) --target base -f docker/humble/Dockerfile-rosfree .
	docker buildx build --pull --platform $(DOCKER_PLATFORMS) -t $(JAMMY_PYTHON38_TAG) --target jammy-python38 -f docker/humble/Dockerfile-rosfree .
	docker buildx build --pull --platform $(DOCKER_PLATFORMS) -t $(MELODIC_TAG) -f docker/melodic/Dockerfile-rosfree .
	docker buildx build --pull --platform $(DOCKER_PLATFORMS) -t $(BIONIC_TAG) -f docker/melodic/Dockerfile-rosfree .

# Push all images (includes building)
push-all: setup-multiarch
	@echo "Building and pushing all flavors for multiple architectures..."
	docker buildx build --push --pull --platform $(DOCKER_PLATFORMS) -t $(NOETIC_TAG) -f docker/noetic/Dockerfile .
	docker buildx build --push --pull --platform $(DOCKER_PLATFORMS) -t $(FOCAL_TAG) --target base -f docker/noetic/Dockerfile-rosfree .
	docker buildx build --push --pull --platform $(DOCKER_PLATFORMS) -t $(FOCAL_PYTHON310_TAG) --target rosfree-python310 -f docker/noetic/Dockerfile-rosfree .
	docker buildx build --push --pull --platform $(DOCKER_PLATFORMS) -t $(HUMBLE_TAG) -f docker/humble/Dockerfile .
	docker buildx build --push --pull --platform $(DOCKER_PLATFORMS) -t $(HUMBLE_PYTHON38_TAG) --target humble-python38 -f docker/humble/Dockerfile .
	docker buildx build --push --pull --platform $(DOCKER_PLATFORMS) -t $(JAMMY_TAG) --target base -f docker/humble/Dockerfile-rosfree .
	docker buildx build --push --pull --platform $(DOCKER_PLATFORMS) -t $(JAMMY_PYTHON38_TAG) --target jammy-python38 -f docker/humble/Dockerfile-rosfree .
	docker buildx build --push --pull --platform $(DOCKER_PLATFORMS) -t $(MELODIC_TAG) -f docker/melodic/Dockerfile-rosfree .
	docker buildx build --push --pull --platform $(DOCKER_PLATFORMS) -t $(BIONIC_TAG) -f docker/melodic/Dockerfile-rosfree .

# Clean up built images
clean:
	@echo "Removing all MOV.AI base images..."
	docker rmi $(ALL_TAGS)
	@echo "Cleanup complete"

# Quick build shortcuts
build: build-all
run: run-humble
test: test-all
