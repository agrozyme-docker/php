#!/bin/bash

function main() {
  local source="$(readlink -f ${BASH_SOURCE[0]})"
  local path="$(dirname ${source})"
  local shell="${path}/php.do.sh"

  alias profile="source ${source}"
  alias php="${shell} php"
  alias composer="${shell} composer"
}

main "$@"
