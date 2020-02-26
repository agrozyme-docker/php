#!/bin/bash

function main() {
  local source="$(readlink -f ${BASH_SOURCE[0]})"
  local path="$(dirname ${source})"
  local php_do="${path}/php.do.sh"

  sudo chmod +x "${path}"/*
  alias profile="source ${source}"

  alias php="${php_do} php"
  alias composer="${php_do} composer"
}

main "$@"
