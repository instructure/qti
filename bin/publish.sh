#!/bin/bash
# shellcheck shell=bash

set -e

current_version=$(ruby -e "require '$(pwd)/lib/qti/version.rb'; puts Qti::VERSION;")
existing_versions=$(gem list --exact qti --remote --all | grep -o '\((.*)\)$' | tr -d '() ')

if [[ $existing_versions == *$current_version* ]]; then
  echo "Gem has already been published ... skipping ..."
else
  gem build ./qti.gemspec
  find qti-*.gem | xargs gem push
fi
