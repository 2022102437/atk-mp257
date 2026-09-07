FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

PACKAGECONFIG = "lldpmed dot1 dot3 snmp cdp edp"

# disable start of service by default
SYSTEMD_AUTO_ENABLE:${PN} = "disable"
INITSCRIPT_PARAMS = "stop 20 0 1 6 ."
