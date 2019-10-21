#!/usr/bin/lua
local core = require("docker-core")

local function main()
  core.run(
    "apk add --no-cache composer patch git $(apk search --no-cache -xq php7* | grep -Ev '(-apache2|-cgi|-dev|-doc|-pecl-ssh2|-pecl-imagick)$')"
  )
  -- core.run("composer self-update")
  core.run("mkdir -p /usr/local/etc/php7 /usr/local/lib/composer /var/www/html")
  core.link_log("/var/log/php7/access.log", "/var/log/php7/error.log")
  core.append_file(
    "/etc/php7/php-fpm.conf",
    "include = /etc/php7/docker/*.conf \n include = /usr/local/etc/php7/*.conf \n"
  )

  local bin = "/usr/bin"
  core.run("%s/composer diagnose", bin)
  core.run("%s/composer global require hirak/prestissimo", bin)
  core.run("%s/composer clear-cache", bin)
end

main()
