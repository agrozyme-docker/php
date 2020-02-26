#!/usr/bin/bash
set -euo pipefail

function cli_command() {
  local image="docker.io/agrozyme/php"
  local path="$(dirname $(readlink -f ${BASH_SOURCE[0]}))"
  local command="${path}/docker.do.sh run_command -v ${PWD}:/var/www/html $@ ${image} "
  echo "${command}"
}

function php() {
  local run="$(cli_command) php $@"
  ${run}
}

function composer() {
  local home="${COMPOSER_HOME:-${HOME}/.composer}"
  mkdir -p "${home}"

  local run="$(cli_command) composer $@"
  # local run="$(cli_command -v ${home}:/usr/local/lib/composer) composer $@"
  ${run}
}

function main() {
  local call=${1:-}

  if [[ -z $(typeset -F "${call}") ]]; then
    return
  fi

  shift
  ${call} "$@"
}

main "$@"
