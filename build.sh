#!/bin/sh -x

[ -z "$DOCKER_REGISTRY" ] && echo "error please specify docker-registry DOCKER_REGISTRY" && exit 1
IMG="$DOCKER_REGISTRY/$(basename $(cat .git/config | tr ' ' '\n' | grep github.com))"

PLATFORM="linux/amd64,linux/arm64,linux/arm/v7,linux/arm/v6"

TAG=$(./get-version.sh)

if echo "$@" | grep -v "force" 2>/dev/null >/dev/null; then
  echo "check if image was already build and pushed - skip check on release version"
  echo "$@" | grep -v "release" && docker pull "$IMG:$TAG" 2>/dev/null >/dev/null && echo "image already build" && exit 1
fi

docker buildx build -q --pull --no-cache --platform "$PLATFORM" -t "$IMG:$TAG" --push .

echo "$@" | grep "release" 2>/dev/null >/dev/null && echo ">> releasing new latest" && docker buildx build -q --pull --platform "$PLATFORM" -t "$IMG:latest" --push .