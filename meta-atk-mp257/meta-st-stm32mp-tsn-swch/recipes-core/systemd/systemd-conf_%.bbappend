FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append:stm32mp2common = " file://wired.network.template "

DEFAULT_ETHERNET_MAIN_INTERFACE = "end0"
DEFAULT_ETHERNET_NOT_USED_INTERFACE = "end1"

do_install:append:stm32mp2common() {
	sed -i -e "s/##ETHX##/${DEFAULT_ETHERNET_MAIN_INTERFACE} !${DEFAULT_ETHERNET_NOT_USED_INTERFACE} en*/" ${WORKDIR}//wired.network.template
	install -m 0644 ${WORKDIR}//wired.network.template ${D}${systemd_unitdir}/network/80-wired.network
}
