--[[
LuCI - Lua Configuration Interface

Copyright 2016 Promwad.com

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

$Id$
]]--

local fs = require "nixio.fs"
local sys = require "luci.sys"

local hosts = "/etc/openvpn/vyprvpnHosts"

m = Map("vypr", "<img src=\"/luci-static/resources/icons/vyprvpn_logo.png\" alt=\"VyprVPN\" width=\"222\">",
	translate("<h2><b>The World's Fastest VPN</b></h2> <br/> VyprVPN is a personal VPN that encrypts your Internet connection. Secure your Wi-Fi connection, protect your online data, defeat throttling, unblock censored content and more.<br />" ..
		"<br>Need an account? <a href=\"https://www.goldenfrog.com/vyprvpn\">Use your promo code to sign up for VyprVPN</a>.<br />" ..
"<br>" ..
"<img src=\"/luci-static/resources/icons/icon_location_blue.png\"> &nbsp;<sup><b>50+ worldwide server locations</b></sup> <br />" ..
"<br>" ..
"<img src=\"/luci-static/resources/icons/icon_servers_blue.png\"> &nbsp;<sup><b>700+ servers</b></sup> <br />" ..
"<br>" ..
"<img src=\"/luci-static/resources/icons/icon_ip_address_blue.png\"> &nbsp;<sup><b>200,000+ global IP addresses</b></sup> <br />" ..
"<br />" ..
"<i><u><b>As featured in</b></u></i><br />" ..
"<img src=\"/luci-static/resources/icons/featured_logos.png\">")
)

s = m:section(TypedSection, "vypr", translate("Settings"),
	"To connect to VyprVPN, fill in your email address or username and password below, " ..
	"select the server location and protocol, check the 'Enable VPN' box and click 'Save and Apply'. " )
s.addremove = false
s.anonymous = true

luci.sys.call("/usr/bin/getCertificate.sh &")

e = s:option(Flag, "enabled", translate("Enable VPN"))
e.rmempty = false
e.default = e.enabled

local username = s:option(Value, "username", translate("Email address or Username"))
local pw = s:option(Value, "password", translate("Password"))
pw.password = true

--
if fs.access(hosts) then
	serverList = s:option(ListValue, "server", translate("Server location"))
	for l in io.lines(hosts) do
		serverList:value(l)
	end
	-- serverList.write = function(self, section, value)
	-- 	Value.write(self, section, value)
	-- end
end

protocolList = s:option(ListValue, "protocol", translate("Protocol"))
protocolList:value("OpenVPN - 160-bit")
protocolList:value("OpenVPN - 256-bit")
-- protocolList.write = function(self, section, value)
-- --      Value.write(self, section, value)
-- -- end
--

p = m:section(TypedSection, "vypr", translate("VPN Status"), "")
p.addremove = false
p.anonymous = true

st = p:option(DummyValue, "_active")
st.template = "get_status_info"

return m
