#!/bin/bash
set -euo pipefail
docker-core.sh
rm -f /run/php-fpm7/php-fpm.pid
exec php-fpm7 -F
