FROM agrozyme/alpine:3.8
COPY source /

RUN set -euxo pipefail \
  && chmod +x /usr/local/bin/*.sh \
  && apk add --no-cache php7 php7-fpm php7-opcache \
  && mkdir -p /run/php-fpm7 /usr/local/etc/php7 /var/www/html \
  && chown -R core:core /var/www/html \
  && ln -sf /dev/stdout /var/log/php7/access.log \
  && ln -sf /dev/stderr /var/log/php7/error.log \
  && sed -ri \
  -e 's!^[;[:space:]]*error_log[[:space:]]*=.*$!error_log = /var/log/php7/error.log!i' \
  -e 's/^[;[:space:]]*log_level[[:space:]]*=.*$/log_level = warning/i' \
  -e 's/^[;[:space:]]*daemonize[[:space:]]*=.*$/daemonize = no/i' \
  -e '$ a include=/usr/local/etc/php7/*.conf' \
  /etc/php7/php-fpm.conf \
  && sed -ri \
  -e 's!^[;[:space:]]*access.log[[:space:]]*=.*$!access.log = /var/log/php7/access.log!i' \
  -e 's/^[;[:space:]]*user[[:space:]]*=.*$/user = core/i' \
  -e 's/^[;[:space:]]*group[[:space:]]*=.*$/group = core/i' \
  -e 's/^[;[:space:]]*listen[[:space:]]*=.*$/listen = 9000/i' \
  -e 's/^[;[:space:]]*catch_workers_output[[:space:]]*=.*$/catch_workers_output = yes/i' \
  -e 's/^[;[:space:]]*clear_env[[:space:]]*=.*$/clear_env = no/i' \
  /etc/php7/php-fpm.d/www.conf \
  && sed -ri \
  -e 's/^[;[:space:]]*precision[[:space:]]*=.*$/precision = -1/i' \
  -e 's/^[;[:space:]]*date.timezone[[:space:]]*=.*$/date.timezone = UTC/i' \
  -e 's/^[;[:space:]]*mysqlnd.collect_statistics[[:space:]]*=.*$/mysqlnd.collect_statistics = Off/i' \
  -e 's/^[;[:space:]]*session.use_strict_mode[[:space:]]*=.*$/session.use_strict_mode = 1/i' \
  -e 's/^[;[:space:]]*session.cookie_httponly[[:space:]]*=.*$/session.cookie_httponly = On/i' \
  -e 's/^[;[:space:]]*session.sid_length[[:space:]]*=.*$/session.sid_length = 256/i' \
  -e 's/^[;[:space:]]*session.sid_bits_per_character[[:space:]]*=.*$/session.sid_bits_per_character = 4/i' \
  -e 's/^[;[:space:]]*opcache.enable_cli[[:space:]]*=.*$/opcache.enable_cli = 1/i' \
  -e 's/^[;[:space:]]*opcache.max_accelerated_files[[:space:]]*=.*$/opcache.max_accelerated_files = 1000000/i' \
  -e 's/^[;[:space:]]*opcache.revalidate_freq[[:space:]]*=.*$/opcache.revalidate_freq = 0/i' \
  -e 's/^[;[:space:]]*opcache.revalidate_path[[:space:]]*=.*$/opcache.revalidate_path = 1/i' \
  /etc/php7/php.ini

ENV PHP_INI_SCAN_DIR=/etc/php7/conf.d:/usr/local/etc/php7
WORKDIR /var/www/html
EXPOSE 9000
CMD ["agrozyme.php.command.sh"]
