
# ----------------------------------------------
# list of packages to use for switch usage only
TSN_PACKAGES_SWITCH_systemd ?= " \
    ttt-ip-st-common \
    \
    ttt-ip-switch \
    "
TSN_PACKAGES_SWITCH_sysvinit ?= " \
    ttt-ip-switch-sysvinit \
    "

TSN_PACKAGES_SWITCH ?= "${@bb.utils.contains('DISTRO_FEATURES','systemd','${TSN_PACKAGES_SWITCH_systemd}','${TSN_PACKAGES_SWITCH_sysvinit}',d)}"


#  ----------------------------------------------
# list of packages to use for tsn
TSN_PACKAGES_TSN_COMMON ?= " \
    bridge-utils \
    lldpd \
    mstpd \
    tsntool \
    restart-script \
    de-ptp-bin \
    ietf-ptp-yang-module \
    ietf-interfaces-yang-module \
    ieee802-dot1q-bridge-yang-module \
    ieee802-dot1q-fqtss-yang-module \
    ieee802-dot1ab-lldp-yang-module \
    ieee8021-mstp-yang-module \
    sysrepo-module-versions-yang-module \
    ieee802-dot1cb-frer-yang-module \
    ieee802-dot1cb-stream-identification-yang-module \
    ieee802-dot1cb-stream-identification-params-yang-module \
    netopeer2-server \
    \
    ieee-8021-bridge-mib \
    ieee-8021-mstp-mib   \
    ieee8021qbridgemib \
    net-snmp-server \
"

# ----------------------------------------------
# list of packages to use for tsn with networkd with usage only
TSN_PACKAGES_TSN_NETWORKD_systemd  ?= " \
    ${TSN_PACKAGES_TSN_COMMON} \
    \
    ttt-ip-st-common \
    \
    ttt-ip-switch \
    ttt-ip-tsn-systemd \
    "
TSN_PACKAGES_TSN_NETWORKD ?= "${@bb.utils.contains('DISTRO_FEATURES','systemd','${TSN_PACKAGES_TSN_NETWORKD_systemd}','${TSN_PACKAGES_SWITCH_sysvinit}',d)}"

# ----------------------------------------------
# list of packages to use for tsn with networkd with usage only
TSN_PACKAGES_TSN_MONO ?= " \
    ${TSN_PACKAGES_TSN_COMMON} \
    \
    ttt-ip-st-common \
    \
    ttt-ip-tsn \
    "

TSN_PACKAGES_TSN_NETWORKD ?= "${@bb.utils.contains('DISTRO_FEATURES','systemd','${TSN_PACKAGES_TSN_NETWORKD_systemd}','${TSN_PACKAGES_TSN_MONO}',d)}"

# ----------------------------------------------
TSN_PACKAGES ??= " \
    ${@bb.utils.contains('TSN_PROFILE','SWICTH','${TSN_PACKAGES_SWITCH}','',d)} \
    ${@bb.utils.contains('TSN_PROFILE','TSN_NETWORKD','${TSN_PACKAGES_TSN_NETWORKD}','',d)} \
    ${@bb.utils.contains('TSN_PROFILE','TSN_MONO','${TSN_PACKAGES_TSN_MONO}','',d)} \
    "
