--
local NXFS = require "nixio.fs"
local SYS  = require "luci.sys"
local HTTP = require "luci.http"
local DISP = require "luci.dispatcher"
local UTIL = require "luci.util"


m = Map("clash", translate("Clash Client"))
m:section(SimpleSection).template  = "clash/status"
s = m:section(TypedSection, "clash")
s.anonymous = true



o = s:option( Flag, "enable")
o.title = translate("Enable Clash")
o.default = 0
o.rmempty = false
o.description = translate("After clash start running, wait a moment for servers to resolve,enjoy")



o = s:option(Value, "proxy_port")
o.title = translate("* Clash Redir Port")
o.default = 8236
o.datatype = "port"
o.rmempty = false
o.description = translate("Port must be the same as in your clash config file , redir-port: 8236")


o = s:option(Value, "subscribe_url")
o.title = translate("Subcription Url")
o.description = translate("You can manually place config file in  /etc/clash/config.yml")
o.rmempty = true

o = s:option(Button,"update")
o.title = translate("Update Subcription")
o.inputtitle = translate("Update Configuration")
o.inputstyle = "reload"
o.write = function()
  os.execute("mv /etc/clash/config.yml /etc/clash/config.bak")
  SYS.call("bash /usr/share/clash/clash.sh >>/tmp/clash.log 2>&1")
  HTTP.redirect(DISP.build_url("admin", "services", "clash"))
end


o = s:option(Button,"start")
o.title = translate("Start Client")
o.inputtitle = translate("Start Client")
o.inputstyle = "reload"
o.write = function()
  os.execute("/etc/init.d/clash start >/dev/null 2>&1")
  HTTP.redirect(DISP.build_url("admin", "services", "clash"))
end

o = s:option(Button,"stop")
o.title = translate("Stop Client")
o.inputtitle = translate("Stop Client")
o.inputstyle = "reload"
o.write = function()
  os.execute("/etc/init.d/clash stop >/dev/null 2>&1")
  HTTP.redirect(DISP.build_url("admin", "services", "clash"))
end



return m

