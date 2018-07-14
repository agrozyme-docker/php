FROM alpine:3.8
COPY docker/ /docker/

RUN set -ex \
  && chmod +x /docker/*.sh \
  && apk add --no-cache $(apk search --no-cache -xq php7* | grep -Ev "(\-apache2|\-cgi|\-dev|\-doc)$" | sort) \
  && mkdir -p /run/php-fpm7 /usr/local/etc/php7 /var/www/html \
  && chown -R nobody:nobody /var/www/html \
  && ln -sf /dev/stdout /var/log/php7/access.log \
  && ln -sf /dev/stderr /var/log/php7/error.log \
  && sed -ri \
  -e 's!^;daemonize = yes!daemonize = no!' \
  -e 's!^;error_log = log/php7/error.log!error_log = /var/log/php7/error.log!' \
  -e '$ a include=/usr/local/etc/php7/*.conf' \
  /etc/php7/php-fpm.conf \
  && sed -ri \
  -e 's!^listen = 127.0.0.1:9000!listen = 9000!' \
  -e 's!^;access.log = log/php7/\$pool.access.log!access.log = /var/log/php7/access.log!' \
  -e 's!^;catch_workers_output !catch_workers_output !' \
  -e 's!^;clear_env !clear_env !' \
  /etc/php7/php-fpm.d/www.conf

ENV PHP_INI_SCAN_DIR=/etc/php7/conf.d:/usr/local/etc/php7
WORKDIR /var/www/html
EXPOSE 9000
CMD ["/docker/agrozyme.php.command.sh"]