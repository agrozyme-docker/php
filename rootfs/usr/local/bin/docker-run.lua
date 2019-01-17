#!/usr/bin/lua

local function main()
  local core = require("docker-core")
  core.update_user()
  core.clear_path("/run/php-fpm7")
  core.chown("/var/www/html")
  core.run("php-fpm7 -F")
end

main()
