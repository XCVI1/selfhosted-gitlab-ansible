#!/usr/bin/env bash

set -euo pipefail

GITLAB_URL="${GITLAB_URL:-http://gitlab}"
REGISTRATION_TOKEN="${REGISTRATION_TOKEN:-}"
RUNNER_NAME="${RUNNER_NAME:-auto-docker-runner}"
DOCKER_IMAGE="${DOCKER_IMAGE:-alpine:latest}"

if [ -z "$REGISTRATION_TOKEN" ]; then
  echo "ERROR: REGISTRATION_TOKEN not specified"
  exit 1
fi

if ! docker ps --format '{{.Names}}' | grep -q "^gitlab$"; then
  echo "ERROR: gitlab container is not running"
  exit 1
fi

if ! docker ps --format '{{.Names}}' | grep -q "^gitlab-runner$"; then
  echo "ERROR: gitlab-runner container is not running"
  exit 1
fi

NETWORK=$(docker inspect -f '{{range $k,$v := .NetworkSettings.Networks}}{{$k}}{{end}}' gitlab-runner)

if [ -z "$NETWORK" ]; then
  echo "ERROR: could not detect docker network"
  exit 1
fi

echo "Detected network: $NETWORK"

echo "Waiting for GitLab to become ready..."

until docker exec gitlab curl -s http://localhost/-/health >/dev/null 2>&1; do
  sleep 5
  echo "GitLab not ready yet..."
done

echo "GitLab is healthy"

echo "Registering GitLab Runner..."

docker exec -i gitlab-runner gitlab-runner register \
  --non-interactive \
  --url "$GITLAB_URL" \
  --registration-token "$REGISTRATION_TOKEN" \
  --executor "docker" \
  --docker-image "$DOCKER_IMAGE" \
  --description "$RUNNER_NAME" \
  --docker-network-mode "$NETWORK" \
  --docker-volumes "/var/run/docker.sock:/var/run/docker.sock" \
  --tag-list "docker,auto" \
  --run-untagged="true" \
  --locked="false"

echo "Runner successfully registered"

docker restart gitlab-runner

echo "Runner is ready"

