#!/bin/sh

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
    echo "[INFO]: start service"
    start_daemons
}

stop() {
    stop_daemons
}

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
