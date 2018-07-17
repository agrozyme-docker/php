#!/bin/bash
set -ex
rm -f /run/php-fpm7/php-fpm.pid
exec php-fpm7 -F