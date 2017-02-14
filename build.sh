#!/bin/bash

export COMPOSE_PROJECT_NAME=quiz_qti

function cleanup() {
  exit_code=$?
  set +e
  docker cp testrunner:/app/coverage .
  docker-compose stop
  docker-compose rm -f
  exit $exit_code
}
trap cleanup INT TERM EXIT

set -e

docker-compose build --pull

echo "Running test suite..."
docker-compose run --name testrunner -T testrunner bundle exec rspec
