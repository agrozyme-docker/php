FROM agrozyme/alpine:3.8
COPY docker-command.sh /usr/local/bin/

RUN set -x \
  && chmod +x /usr/local/bin/docker-command.sh \
  && addgroup -g 82 -S www-data \
  && adduser -u 82 -D -S -G www-data www-data \
  && apk add --no-cache $(apk search --no-cache -xq php7* | grep -Ev "(\-apache2|\-cgi|\-dev|\-doc)$" | sort) \
  && mkdir -p /run/php-fpm7 /usr/local/etc/php7 /var/www/html \
  && chown -R www-data:www-data /var/www/html \
  && ln -sf /proc/self/fd/1 /var/log/php7/access.log \
  && ln -sf /proc/self/fd/2 /var/log/php7/error.log \
  && sed -ri \
  -e 's!^;daemonize = yes!daemonize = no!' \
  -e 's!^;error_log = log/php7/error.log!error_log = /var/log/php7/error.log!' \
  -e '$ a include=/usr/local/etc/php7/*.conf' \
  /etc/php7/php-fpm.conf \
  && sed -ri \
  -e 's!^user = nobody!user = www-data!' \
  -e 's!^group = nobody!group = www-data!' \
  -e 's!^listen = 127.0.0.1:9000!listen = 9000!' \
  -e 's!^;access.log = log/php7/\$pool.access.log!access.log = /var/log/php7/access.log!' \
  -e 's!^;catch_workers_output !catch_workers_output !' \
  -e 's!^;clear_env !clear_env !' \
  /etc/php7/php-fpm.d/www.conf

ENV PHP_INI_SCAN_DIR=/etc/php7/conf.d:/usr/local/etc/php7
WORKDIR /var/www/html
EXPOSE 9000
CMD ["docker-command.sh"]