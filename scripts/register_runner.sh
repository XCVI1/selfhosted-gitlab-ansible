#!/usr/bin/env bash

set -euo pipefail

REGISTRATION_TOKEN="${1:-${REGISTRATION_TOKEN:-}}"

if [ -z "$REGISTRATION_TOKEN" ]; then
	echo "Usage: $0 <YOUR_TOKEN>"
	exit 1
fi

GITLAB_URL="${GITLAB_URL:-http://gitlab}"
RUNNER_NAME="${RUNNER_NAME:-auto-docker-runner}"
DOCKER_IMAGE="${DOCKER_IMAGE:-alpine:latest}"

if [ -z "$REGISTRATION_TOKEN" ]; then
  echo "ERROR: REGISTRATION_TOKEN is empty"
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
  echo "ERROR: problem with gitlab network"
  exit 1
fi

echo "Detected network: $NETWORK"

echo "Waiting GitLab"

until docker exec gitlab curl -s http://localhost/-/health >/dev/null 2>&1; do
  sleep 5
  echo "GitLab not ready to connect"
done

echo "Connected to GitLab"

echo "Registering GitLab runner"

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

echo "Runner registered"

docker restart gitlab-runner

echo "GitLab runner is restarted and ready to use"

