SUMMARY = "ST TSN service with systemd-networkd"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/BSD-3-Clause;md5=550794465ba0ec5312d6919e203a55f9"
PR = "r2"

inherit update-rc.d systemd

SRC_URI = " \
	file://ttt-ip-init-tsn-no-networkd.sh \
	file://ttt-ip-init-tsn-sysvinit.sh \
	file://st-tsn.service \
"

FILES:${PN} += "${systemd_unitdir} ${sysconfdir}"
INITSCRIPT_NAME = "ttt-ip-init-tsn-sysvinit.sh"
INITSCRIPT_PARAMS = "defaults 99 99"
SYSTEMD_SERVICE:${PN} = "st-tsn.service"

S = "${WORKDIR}"

do_install() {
	if ${@bb.utils.contains('DISTRO_FEATURES','systemd','true','false',d)}; then
		install -d ${D}${systemd_unitdir}/system ${D}${sbindir}
		install -m 0644 ${WORKDIR}/st-tsn.service ${D}${systemd_unitdir}/system/
		install -m 0755 ${WORKDIR}/ttt-ip-init-tsn-no-networkd.sh ${D}${sbindir}
		sed -i -e "s/^REF_ETH_INTERFACE=.*$/REF_ETH_INTERFACE=${DEFAULT_ETHERNET_MAIN_TSN_BRIDGE_INTERFACE}/" ${D}${sbindir}/ttt-ip-init-tsn-no-networkd.sh
	else
		install -d ${D}${sysconfdir}/init.d
		# tsn
		install -m 0755 ${WORKDIR}/ttt-ip-init-tsn-sysvinit.sh ${D}${sysconfdir}/init.d/ttt-ip-init-tsn-sysvinit.sh
		sed -i -e "s/^REF_ETH_INTERFACE=.*$/REF_ETH_INTERFACE=${DEFAULT_ETHERNET_MAIN_TSN_BRIDGE_INTERFACE}/" ${D}${sysconfdir}/init.d/ttt-ip-init-tsn-sysvinit.sh
	fi
}
