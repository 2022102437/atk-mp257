#!/bin/sh

REF_ETH_INTERFACE=to_be_adapted_to_the_board
IP_REF_NAME=42080000.bus/42080000.bus:ttt-sw@4c000000/4c000000.deip-sw

# read mac address
get_mac() {
    read MAC </sys/class/net/$REF_ETH_INTERFACE/address
    echo "[INFO]: Mac Address of $REF_ETH_INTERFACE: $MAC"
}

get_soc_path() {
    devicetree_path=$(ls -1 -d /sys/devices/platform/* | grep "/soc" | head -n 1)
    if [ -d "$devicetree_path" ];
    then
        SOC_PATH=$devicetree_path
    else
        echo "[ERROR]: /sys/devices/platform/soc* is not available"
        echo ""
        exit 1
    fi

}

wait_sysfs() {
    path=$1
            for i in $(seq 0 5)
        do
            if [ ! -e "$path" ]; then
                break;
            else
                sleep 0.5s
            fi
        done
}

st_configure() {
    get_soc_path
    wait_sysfs $SOC_PATH/$IP_REF_NAME/net/sw0p3/phy/mdiobus
    if [ -e $SOC_PATH/$IP_REF_NAME/net/sw0p3/phy/mdiobus ]; then
        echo -n stmmac-1:04 > $SOC_PATH/$IP_REF_NAME/net/sw0p3/phy/mdiobus
        echo -n stmmac-1:05 > $SOC_PATH/$IP_REF_NAME/net/sw0p2/phy/mdiobus
    else
        echo "[ERROR]: $SOC_PATH/$IP_REF_NAME/net/sw0p3/phy/mdiobus not available"
        echo ""
        exit 1
    fi

    echo 170 > /sys/class/net/sw0p2/phy/delay1000tx_min
    echo 200 > /sys/class/net/sw0p2/phy/delay1000tx_max
    echo 170 > /sys/class/net/sw0p3/phy/delay1000tx_min
    echo 200 > /sys/class/net/sw0p3/phy/delay1000tx_max
    echo 520 > /sys/class/net/sw0p2/phy/delay1000rx_min
    echo 570 > /sys/class/net/sw0p2/phy/delay1000rx_max
    echo 520 > /sys/class/net/sw0p3/phy/delay1000rx_min
    echo 570 > /sys/class/net/sw0p3/phy/delay1000rx_max
}

set_interfaces_mac() {
    get_mac
    ip link set dev sw0ep address $MAC
    # set mac address for sw0p1, sw0p2, sw0p3
    if [ -n "$ST_SPECIFIC_MAC" ]; then
        ip link set dev sw0p1 address $(get_st_mac 1 $MAC)
        ip link set dev sw0p2 address $(get_st_mac 2 $MAC)
        ip link set dev sw0p3 address $(get_st_mac 3 $MAC)
    fi
    ip link set dev sw0ep up
}

set_interfaces_up()
{
    # ask to network to put an ip address on this interface
    # udhcpc -i sw0ep > /dev/null 2>&1 &
    ip addr add 192.168.0.10 dev sw0ep
    ip route add 192.168.0.0/24 dev sw0ep

    sleep 1

    ip link add name br0 type bridge
    ip link set dev br0 up
    ip link set dev sw0p1 master br0 up
    ip link set dev sw0p2 master br0 up
    ip link set dev sw0p3 master br0 up
    ip link set dev sw0ep up
}

# Set the interfaces down like in the interfaces files
# Usage: set_interfaces_down
set_interfaces_down()
{
    ip link set dev br0 down
    ip link delete dev br0

    ip link set dev sw0ep down
}

# Start the deamons as they would do at start
# Usage: start_daemons
start_daemons()
{
    # stop NTP service
    systemctl stop systemd-timesyncd
    systemctl stop ntpd

    ip link set br0 type bridge stp_state 1

    mstpctl addbridge br0
    mstpctl setforcevers br0 mstp
    mstpctl setvid2fid br0 0:1

    systemctl start lldpd &

    systemctl start deptp &

    #systemctl start snmpd &

    /usr/share/netopeer2-server/netopeer2-server-service start &
}

# Stop the daemons
# Usage: stop_daemons
stop_daemons()
{
    mstpctl delbridge br0
    #systemctl stop snmpd &
    systemctl stop lldpd &
    systemctl stop deptp &
    /usr/share/netopeer2-server/netopeer2-server-service stop
}

start()
{
    echo "[INFO]: ST set brigde interface"
    st_configure
    set_interfaces_mac
    set_interfaces_up
    echo "[INFO]: start service"
    start_daemons
}

stop() {
    stop_daemons
    set_interfaces_down
}

if [ -e /usr/bin/st-specific_macaddress.sh ]; then
    source  /usr/bin/st-specific_macaddress.sh
fi

case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        stop
        start
        ;;
    restore)
        /usr/share/netopeer2-server/netopeer2-server-service restore
        ;;
esac
exit 0
