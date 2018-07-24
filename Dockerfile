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
  -e 's!^;daemonize = yes!daemonize = no!' \
  -e 's!^;error_log = log/php7/error.log!error_log = /var/log/php7/error.log!' \
  -e '$ a include=/usr/local/etc/php7/*.conf' \
  /etc/php7/php-fpm.conf \
  && sed -ri \
  -e 's!^user = nobody!user = core!' \
  -e 's!^group = nobody!group = core!' \
  -e 's!^listen = 127.0.0.1:9000!listen = 9000!' \
  -e 's!^;access.log = log/php7/\$pool.access.log!access.log = /var/log/php7/access.log!' \
  -e 's!^;catch_workers_output !catch_workers_output !' \
  -e 's!^;clear_env !clear_env !' \
  /etc/php7/php-fpm.d/www.conf \
  && sed -ri \
  -e 's!^precision = 14!precision = -1!' \
  -e 's!^;date.timezone =!date.timezone = UTC!' \
  -e 's!^mysqlnd.collect_statistics = On!mysqlnd.collect_statistics = Off!' \
  -e 's!^session.use_strict_mode = 0!session.use_strict_mode = 1!' \
  -e 's!^session.cookie_httponly =!session.cookie_httponly = On!' \
  -e 's!^session.sid_length = 26!session.sid_length = 256!' \
  -e 's!^session.sid_bits_per_character = 5!session.sid_bits_per_character = 4!' \
  -e 's!^;opcache.enable_cli=0!opcache.enable_cli=1!' \
  -e 's!^;opcache.max_accelerated_files=10000!opcache.max_accelerated_files=1000000!' \
  -e 's!^;opcache.revalidate_freq=2!opcache.revalidate_freq=0!' \
  -e 's!^;opcache.revalidate_path=0!opcache.revalidate_path=1!' \
  /etc/php7/php.ini

ENV PHP_INI_SCAN_DIR=/etc/php7/conf.d:/usr/local/etc/php7
WORKDIR /var/www/html
EXPOSE 9000
CMD ["agrozyme.php.command.sh"]
