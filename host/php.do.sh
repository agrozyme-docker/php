#!/usr/bin/bash
set -euo pipefail

function source_file() {
  echo "$(readlink -f ${BASH_SOURCE[0]})"
}

function source_path() {
  echo "$(dirname $(source_file))"
}

function setup_alias() {
  local run="$(source_file)"

  alias php="${run} php"
  alias composer="${run} composer"
}

function cli_command() {
  local image="docker.io/agrozyme/php"
  local command="$(source_path)/docker.do.sh run_command -v ${PWD}:/var/www/html $@ ${image} "
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
