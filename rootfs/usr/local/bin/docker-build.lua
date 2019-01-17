#!/usr/bin/lua
local core = require("docker-core")

local function main()
  -- core.run([[apk add --no-cache $(apk search --no-cache -xq php7* | grep -Ev "(\-apache2|\-cgi|\-dev|\-doc)$")]])
  core.run("apk add --no-cache composer php7-fpm php7-opcache")
  core.run("composer self-update")
  core.run("mkdir -p /usr/local/etc/php7 /var/www/html")
  core.link_log("/var/log/php7/access.log", "/var/log/php7/error.log")
  core.append_file("/etc/php7/php-fpm.conf", "include = /usr/local/etc/php7/*.conf \n")
end

main()
