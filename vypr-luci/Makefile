#
# Copyright (C) 2016 Promwad.com
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=vypr-luci
PKG_VERSION:=0.0.1
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk

define Package/luci-app-vypr
  SECTION:=luci
  CATEGORY:=LuCI
  SUBMENU:=3. Applications
  DEPENDS:=+luci +openvpn-openssl +wget +unzip
  TITLE:=VyprVPN configuration module
  URL:=https://www.goldenfrog.com/vyprvpn
endef

define Package/luci-app-vypr/conffiles
/etc/config/vypr
endef

define Package/luci-app-vypr/description
 This package contains a graphical interface for VyprVPN management on OpenWrt.
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Compile/Default
endef

define Build/Compile
	$(call Build/Compile/Default)
endef

define Package/luci-app-vypr/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller
	$(INSTALL_DATA) ./files/vyprctl.lua $(1)/usr/lib/lua/luci/controller/
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi/vypr
	$(INSTALL_DATA) ./files/vypr.lua $(1)/usr/lib/lua/luci/model/cbi/vypr/
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/view
	$(INSTALL_DATA) ./files/get_status_info.htm $(1)/usr/lib/lua/luci/view/
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/view/vypr
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DATA) ./files/vypr.config $(1)/etc/config/vypr
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) ./files/check_openvpn.sh $(1)/usr/bin/check_openvpn.sh
	$(INSTALL_BIN) ./files/getCertificate.sh $(1)/usr/bin/getCertificate.sh
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/vypr.init $(1)/etc/init.d/vypr
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_BIN) ./files/luci-vypr $(1)/etc/uci-defaults
	$(INSTALL_BIN) ./files/vyprvpn $(1)/etc/uci-defaults
	$(INSTALL_DIR) $(1)/etc
	$(INSTALL_BIN) ./files/rc.local $(1)/etc/rc.local
	$(INSTALL_DIR) $(1)/www/luci-static/resources
	$(INSTALL_DATA) ./files/vypr_logo.png $(1)/www/luci-static/resources
	$(INSTALL_DIR) $(1)/etc/openvpn
	$(INSTALL_DATA) ./files/openvpn160_template $(1)/etc/openvpn/
	$(INSTALL_DATA) ./files/openvpn256_template $(1)/etc/openvpn/
	$(INSTALL_DATA) ./files/vyprvpnHosts $(1)/etc/openvpn/
	$(INSTALL_DATA) ./files/vyprvpnHostsKeys $(1)/etc/openvpn/
endef

$(eval $(call BuildPackage,luci-app-vypr))
