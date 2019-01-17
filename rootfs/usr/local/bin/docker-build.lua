#!/usr/bin/lua
local core = require("docker-core")

local function update_php_fpm_conf(target, items)
  local pcre = items.pcre
  local text = core.read_file(target)
  text = pcre.gsub(text, [[^[;\s]*(error_log)[\s]*=.*$]], "%1 = /var/log/php7/error.log", nil, "im")
  text = pcre.gsub(text, [[^[;\s]*(log_level)[\s]*=.*$]], "%1 = warning", nil, "im")
  text = pcre.gsub(text, [[^[;\s]*(daemonize)[\s]*=.*$]], "%1 = no", nil, "im")
  core.write_file(target, text)
  core.append_file(target, "include=/usr/local/etc/php7/*.conf \n")
end

local function update_www_conf(target, items)
  local pcre = items.pcre
  local text = core.read_file(target)
  text = pcre.gsub(text, [[^[;\s]*(access.log)[\s]*=.*$]], "%1 = /var/log/php7/access.log", nil, "im")
  text = pcre.gsub(text, [[^[;\s]*(user|group)[\s]*=.*$]], "%1 = core", nil, "im")
  text = pcre.gsub(text, [[^[;\s]*(listen)[\s]*=.*$]], "%1 = 9000", nil, "im")
  text = pcre.gsub(text, [[^[;\s]*(catch_workers_output)[\s]*=.*$]], "%1 = yes", nil, "im")
  text = pcre.gsub(text, [[^[;\s]*(clear_env)[\s]*=.*$]], "%1 = no", nil, "im")
  core.write_file(target, text)
end

local function update_php_ini(target, items)
  local pcre = items.pcre
  local text = core.read_file(target)
  text = pcre.gsub(text, [[^[;\s]*(precision)[\s]*=.*$]], "%1 = -1", nil, "im")
  text = pcre.gsub(text, [[^[;\s]*(date.timezone)[\s]*=.*$]], "%1 = UTC", nil, "im")
  text = pcre.gsub(text, [[^[;\s]*(mysqlnd.collect_statistics)[\s]*=.*$]], "%1 = Off", nil, "im")
  text = pcre.gsub(text, [[^[;\s]*(session.use_strict_mode)[\s]*=.*$]], "%1 = 1", nil, "im")
  text = pcre.gsub(text, [[^[;\s]*(session.cookie_httponly)[\s]*=.*$]], "%1 = On", nil, "im")
  text = pcre.gsub(text, [[^[;\s]*(session.sid_length)[\s]*=.*$]], "%1 = 64", nil, "im")
  text = pcre.gsub(text, [[^[;\s]*(session.sid_bits_per_character)[\s]*=.*$]], "%1 = 4", nil, "im")
  text = pcre.gsub(text, [[^[;\s]*(session.enable_cli)[\s]*=.*$]], "%1 = 1", nil, "im")
  text = pcre.gsub(text, [[^[;\s]*(session.max_accelerated_files)[\s]*=.*$]], "%1 = 1000000", nil, "im")
  text = pcre.gsub(text, [[^[;\s]*(session.revalidate_freq)[\s]*=.*$]], "%1 = 0", nil, "im")
  text = pcre.gsub(text, [[^[;\s]*(session.revalidate_path)[\s]*=.*$]], "%1 = 1", nil, "im")
  core.write_file(target, text)
end

local function replace_setting()
  local requires = {pcre = "rex_pcre"}
  local updates = {
    ["/etc/php7/php-fpm.conf"] = update_php_fpm_conf,
    ["/etc/php7/php-fpm.d/www.conf"] = update_www_conf,
    ["/etc/php7/php.ini"] = update_php_ini
  }
  core.replace_files(requires, updates)
end

local function main()
  -- core.run("apk add --no-cache lua-rex-pcre")
  -- core.run([[apk add --no-cache $(apk search --no-cache -xq php7* | grep -Ev "(\-apache2|\-cgi|\-dev|\-doc)$")]])
  core.run("apk add --no-cache composer php7-fpm php7-opcache")
  core.run("composer self-update")
  core.run("mkdir -p /usr/local/etc/php7 /var/www/html")
  core.link_log("/var/log/php7/access.log", "/var/log/php7/error.log")
  replace_setting()
end

main()
