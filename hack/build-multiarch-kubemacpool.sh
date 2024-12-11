#!/bin/bash

ARCH=$1
PLATFORMS=$2
KUBEMACPOOL_IMAGE_TAGGED=$3
KUBEMACPOOL_IMAGE_GIT_TAGGED=$4
DOCKER_BUILDER=$5
OCI_BIN=$6
REGISTRY=$7

if [ "$OCI_BIN" == "docker" ]; then
    ARCH=$ARCH PLATFORMS=$PLATFORMS KUBEMACPOOL_IMAGE_TAGGED=$KUBEMACPOOL_IMAGE_TAGGED KUBEMACPOOL_IMAGE_GIT_TAGGED=$KUBEMACPOOL_IMAGE_GIT_TAGGED DOCKER_BUILDER=$DOCKER_BUILDER REGISTRY=$REGISTRY ./hack/build-kubemacpool-docker.sh
elif [ "$OCI_BIN" == "podman" ]; then
    ARCH=$ARCH PLATFORMS=$PLATFORMS KUBEMACPOOL_IMAGE_TAGGED=$KUBEMACPOOL_IMAGE_TAGGED KUBEMACPOOL_IMAGE_GIT_TAGGED=$KUBEMACPOOL_IMAGE_GIT_TAGGED ./hack/build-kubemacpool-podman.sh
else
    echo "Unsupported OCI_BIN value: $OCI_BIN"
    exit 1
fi

