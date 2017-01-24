#!/bin/bash

export COMPOSE_PROJECT_NAME=quiz_qti

function cleanup() {
  exit_code=$?
  set +e
  docker-compose rm -f
  docker rmi -f $(docker images -qf "dangling=true") &>/dev/null
  exit $exit_code
}
trap cleanup INT TERM EXIT

set -e

docker-compose build --pull
docker-compose run -T testrunner bin/rspec spec
