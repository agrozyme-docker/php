#!/bin/bash
set -euo pipefail

function main() {
  agrozyme.alpine.function.sh change_core
  rm -f /run/php-fpm7/php-fpm.pid
  exec php-fpm7 -F
}

main "$@"
