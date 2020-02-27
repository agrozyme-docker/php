#!/usr/bin/lua
local core = require("docker-core")

local function composer_setup(bin)
  local setup = "composer-setup.php"
  core.run("wget -q -O %s https://getcomposer.org/installer", setup)
  core.run("php %s", setup)
  core.run("rm -f %s", setup)
  core.run("chmod +x composer.phar")
  core.run("mv composer.phar %s/composer", bin)
end

local function main()
  local bin = "/usr/local/bin"

  core.run(
    "apk add --no-cache patch git $(apk search --no-cache -xq php7* | grep -Ev '(-apache2|-cgi|-dev|-doc|-pecl-gmagick)$')"
  )

  composer_setup(bin)
  core.run("mkdir -p /usr/local/etc/php7 /var/www/html")
  core.link_log("/var/log/php7/access.log", "/var/log/php7/error.log")
  core.append_file(
    "/etc/php7/php-fpm.conf",
    "include=/etc/php7/docker/*.conf \n",
    "include=/usr/local/etc/php7/*.conf \n"
  )

  core.run("%s/composer diagnose", bin)
  core.run("%s/composer global require hirak/prestissimo", bin)
  core.run("%s/composer clear-cache", bin)
  core.chown("/usr/local/lib/composer")
end

main()
