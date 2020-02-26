FROM docker.io/agrozyme/alpine:3.11
COPY rootfs /
ENV \
  PHP_INI_SCAN_DIR=/etc/php7/conf.d:/etc/php7/docker:/usr/local/etc/php7 \
  COMPOSER_ALLOW_SUPERUSER=1 \
  COMPOSER_MEMORY_LIMIT=-1 \
  COMPOSER_HOME=/usr/local/lib/composer
RUN set +e -uxo pipefail && chmod +x /usr/local/bin/* && /usr/local/bin/docker-build.lua
WORKDIR /var/www/html
EXPOSE 9000
CMD ["/usr/local/bin/docker-run.lua"]
