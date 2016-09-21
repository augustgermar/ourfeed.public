#!/bin/sh
PROTOCOL="$(uci get vypr.general.protocol)"
if [ "$PROTOCOL" == "OpenVPN - 256-bit" ] ; then
	FILENAME="/etc/openvpn/openvpn256_template"
	PORT=443
elif [ "$PROTOCOL" == "OpenVPN - 160-bit" ] ; then
	FILENAME="/etc/openvpn/openvpn160_template"
	PORT=1194
else
	exit 1
fi

SERVER=$(uci get vypr.general.server)

if [ -z "$SERVER" ]; then
	exit 2
fi

DESTINATION="/etc/openvpn/vypr.ovpn"
HOSTSKEYS="/etc/openvpn/vyprvpnHostsKeys"
HOSTPREFIX=$(grep $SERVER $HOSTSKEYS | awk '{ print $NF }' | awk -F. '{ print $1 }')
cat $FILENAME | sed -e 's/\$1/'$HOSTPREFIX'/g' | sed -e 's/\$2/'$PORT'/g' > $DESTINATION

if [ "$(uci get vypr.general.enabled)" == "1" ]; then
	/etc/init.d/vypr restart
fi

exit 0
