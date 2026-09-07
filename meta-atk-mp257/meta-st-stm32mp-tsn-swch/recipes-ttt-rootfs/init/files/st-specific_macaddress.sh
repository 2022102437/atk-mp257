ST_SPECIFIC_MAC=1

# for stm32mp257f-ev1 board, the interface end0 (aka ethernet0.eth2) need to be desactivated during
# the init of syspl

U_BOOT_FW_ENV=/usr/bin/fw_printenv

# param1: interface name (ex.end1, end0, eth0, eth1)
get_mac_from_sysfs() {
    read MAC </sys/class/net/$1/address
    echo -n $MAC
}


# param 1: index of sw0pX (X = param1)
# param 2: mac address of switch insterface
get_mac_from_endx_interface() {
    switch_mac=$2
    # get last BYTE of mac address
    last_mac=$(echo $switch_mac | sed "s|.*:\([^:]*\)|\1|")
    last_mac_int=$((16#$last_mac))
    case $1 in
    1)
        inc=1
        ;;
    2)
        inc=2
        ;;
    3)
        inc=3
        ;;
    *)
        inc=0
        ;;
    esac
    last_mac_int_inc=$(expr $last_mac_int + $inc)
    echo -n $switch_mac | sed "s|\(.*\):\([^:]*\)|\1|"; printf ":%02x" $last_mac_int_inc
}


get_mac_from_u_boot() {
    [ -e $U_BOOT_FW_ENV ]  || return $(get_mac_from_endx_interface $1 $2)
    case $1 in
    1)
        mac_id=$(fw_printenv -c /etc/fw_env.config.mmc  | grep eth2addr | sed "s/eth2addr=\(.*\)$/\1/")
        ;;
    2)
        mac_id=$(fw_printenv -c /etc/fw_env.config.mmc  | grep eth3addr | sed "s/eth3addr=\(.*\)$/\1/")
        ;;
    3)
        mac_id=$(fw_printenv -c /etc/fw_env.config.mmc  | grep eth4addr | sed "s/eth4addr=\(.*\)$/\1/")
        ;;
    *)
        mac_id=""
        ;;
    esac
    echo -n $mac_id
}

get_st_mac() {
    echo -n $(get_mac_from_u_boot $1 $2)
}
