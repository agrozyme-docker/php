#!/usr/bin/bash
set -euo pipefail

function cli_options() {
  local network=${DOCKER_NETWORK:-network}
  local user=$(id -u):$(id -g)

  local items
  declare -A items=(
    ['image']=agrozyme/php
    ['run']="docker run -it --rm -u=${user} --network=${network} -v ${PWD}:/var/www/html"
    ['command']="php -c /etc/php7/php-cli.ini "
  )

  items=$(declare -p items)
  echo "${items#*=}"
}

function php() {
  local items=$(cli_options)
  eval "declare -A items=${items}"

  local run="${items['run']} ${items['image']} ${items['command']}"

  ${run} "$@"
}

function composer() {
  local items=$(cli_options)
  eval "declare -A items=${items}"

  local home=${COMPOSER_HOME:-${HOME}/.composer}
  local run="${items['run']} ${items['image']} ${items['command']}/composer"
  # local run="${items['run']} -v ${home}:/usr/local/lib/composer ${items['image']} ${items['command']}/composer"

  mkdir -p "${home}"
  ${run} "$@"
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
