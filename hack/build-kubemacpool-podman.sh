#!/bin/bash

if [ -z "$ARCH" ] || [ -z "$PLATFORMS" ] || [ -z "$KUBEMACPOOL_IMAGE_TAGGED_1" ]; then
    echo "Error: ARCH, PLATFORMS, and KUBEMACPOOL_IMAGE_TAGGED_1 must be set."
    exit 1
fi

IFS=',' read -r -a PLATFORM_LIST <<< "$PLATFORMS"

# Remove any existing manifest and image
podman manifest rm "${KUBEMACPOOL_IMAGE_TAGGED_1}" || true
podman manifest rm "${KUBEMACPOOL_IMAGE_TAGGED_2}" || true
podman rmi "${KUBEMACPOOL_IMAGE_TAGGED_1}" || true
podman rmi "${KUBEMACPOOL_IMAGE_TAGGED_2}" || true

podman manifest create "${KUBEMACPOOL_IMAGE_TAGGED_1}"

for platform in "${PLATFORM_LIST[@]}"; do
    podman build \
        --no-cache \
        --build-arg BUILD_ARCH="$ARCH" \
        --platform "$platform" \
        --manifest "${KUBEMACPOOL_IMAGE_TAGGED_1}" \
        -f build/Dockerfile .
done
