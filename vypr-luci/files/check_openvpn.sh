#!/bin/sh

SERVICES_DIRECTORY="/etc/init.d/"
OVPN_FILE_DIRECTORY="/etc/openvpn/"
SLEEP=60
[ -z "$1" ] || SLEEP=$1
VPN=""

ping_server () {
	#echo "ping"
	SERVER=$( grep "^remote" "$OVPN_FILE_DIRECTORY$VPN.ovpn" | sed 's/^remote //g' | sed 's/ .*$//g' )
	# SERVER="8.8.8.8"
	ping -w 2 -c 1 ${SERVER} >/dev/null 2>&1
	if [ ! $? = 0 ]; then
		$SERVICES_DIRECTORY$VPN restart >/dev/null 2>&1
		#echo restart
	fi
}

run () {
	if [ -z $(pidof openvpn) ] ; then
		$SERVICES_DIRECTORY$VPN start
	else
		ping_server
	fi
}

checktun () {                                                                                                                                                          
        TUN=`/sbin/ifconfig | grep tun0`                                                                                                                              
        IPNAT=`/usr/sbin/iptables -t nat -vL zone_wan_postrouting | /bin/grep MASQUERADE`                                                                             
                                                                                                                                                                       
        if [ "${TUN}" == "" ] ; then                                                                                                                                  
                if [ "${IPNAT}" != "" ] ; then                                                                                                                        
                /usr/sbin/iptables -t nat -D zone_wan_postrouting -m id --id 0x66773300 -j MASQUERADE                                                                  
                fi                                                                                                                                                    
                                                                                                                                                                       
        else                                                                                                                                                          
                if [ "${IPNAT}" == "" ] ; then                                                                                                                         
                        /usr/sbin/iptables -t nat -A zone_wan_postrouting -m id --id 0x66773300 -j MASQUERADE                                                         
                                                                                                                                                                       
                fi                                                                                                                                                     
        fi                                                                                                                                                            
}       

while true; do
	if [ "$(uci get vypr.general.enabled)" == "1" ] && [ $(uci get hma.general.enabled) == "0" ] ; then
		VPN="vypr"
		checktun
                run 
	elif [ "$(uci get vypr.general.enabled)" == "0" ] && [ "$(uci get hma.general.enabled)" == "1" ] ; then
		VPN="hma"
		checktun
                run
	fi
	sleep $SLEEP
done
