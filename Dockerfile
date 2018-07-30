FROM agrozyme/alpine:3.8
COPY source /

RUN set -euxo pipefail \
  && chmod +x /usr/local/bin/*.sh \
  && apk add --no-cache php7 php7-fpm php7-opcache \
  && mkdir -p /usr/local/etc/php7 /var/www/html \
  && chown -R core:core /var/www/html \
  && ln -sf /dev/stdout /var/log/php7/access.log \
  && ln -sf /dev/stderr /var/log/php7/error.log \
  && sed -ri \
  -e 's!^[;[:space:]]*(error_log)[[:space:]]*=.*$!\1 = /var/log/php7/error.log!i' \
  -e 's/^[;[:space:]]*(log_level)[[:space:]]*=.*$/\1 = warning/i' \
  -e 's/^[;[:space:]]*(daemonize)[[:space:]]*=.*$/\1 = no/i' \
  -e '$ a include=/usr/local/etc/php7/*.conf' \
  /etc/php7/php-fpm.conf \
  && sed -ri \
  -e 's!^[;[:space:]]*(access.log)[[:space:]]*=.*$!\1 = /var/log/php7/access.log!i' \
  -e 's/^[;[:space:]]*(user)[[:space:]]*=.*$/\1 = core/i' \
  -e 's/^[;[:space:]]*(group)[[:space:]]*=.*$/\1 = core/i' \
  -e 's/^[;[:space:]]*(listen)[[:space:]]*=.*$/\1 = 9000/i' \
  -e 's/^[;[:space:]]*(catch_workers_output)[[:space:]]*=.*$/\1 = yes/i' \
  -e 's/^[;[:space:]]*(clear_env)[[:space:]]*=.*$/\1 = no/i' \
  /etc/php7/php-fpm.d/www.conf \
  && sed -ri \
  -e 's/^[;[:space:]]*(precision)[[:space:]]*=.*$/\1 = -1/i' \
  -e 's/^[;[:space:]]*(date.timezone)[[:space:]]*=.*$/\1 = UTC/i' \
  -e 's/^[;[:space:]]*(mysqlnd.collect_statistics)[[:space:]]*=.*$/\1 = Off/i' \
  -e 's/^[;[:space:]]*(session.use_strict_mode)[[:space:]]*=.*$/\1 = 1/i' \
  -e 's/^[;[:space:]]*(session.cookie_httponly)[[:space:]]*=.*$/\1 = On/i' \
  -e 's/^[;[:space:]]*(session.sid_length)[[:space:]]*=.*$/\1 = 64/i' \
  -e 's/^[;[:space:]]*(session.sid_bits_per_character)[[:space:]]*=.*$/\1 = 4/i' \
  -e 's/^[;[:space:]]*(opcache.enable_cli)[[:space:]]*=.*$/\1 = 1/i' \
  -e 's/^[;[:space:]]*(opcache.max_accelerated_files)[[:space:]]*=.*$/\1 = 1000000/i' \
  -e 's/^[;[:space:]]*(opcache.revalidate_freq)[[:space:]]*=.*$/\1 = 0/i' \
  -e 's/^[;[:space:]]*(opcache.revalidate_path)[[:space:]]*=.*$/\1 = 1/i' \
  /etc/php7/php.ini

ENV PHP_INI_SCAN_DIR=/etc/php7/conf.d:/usr/local/etc/php7
WORKDIR /var/www/html
EXPOSE 9000
CMD ["agrozyme.php.command.sh"]
