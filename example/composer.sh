#!/usr/bin/bash
set -euo pipefail

function main() {
  local network=${DOCKER_NETWORK:-ingress}
  local home=${COMPOSER_HOME:-${HOME}/.composer}
  local user=$(id -u):$(id -g)
  local image=agrozyme/php
  local run="docker run -it --rm -u=${user} --network=${network} -v ${PWD}:/var/www/html -v ${home}:/usr/local/lib/composer ${image}"

  mkdir -p "${home}"
  ${run} composer "$@"
}

main "$@"
