SUMMARY = "ST Initialisation for TSN purpose"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/BSD-3-Clause;md5=550794465ba0ec5312d6919e203a55f9"
PR = "r2"

inherit systemd

SRC_URI = " \
	file://ttt-ip-common.sh \
	file://st-init-switch.service \
	\
	file://72-br0.netdev \
	file://72-br0.network \
	file://72-switch-ep-dhcp.network.sample \
	file://72-switch-ep-static-ip.network \
	file://72-switch.network \
	"

FILES:${PN} += "${systemd_unitdir} ${sysconfdir}"
SYSTEMD_SERVICE:${PN} = "st-init-switch.service"

S = "${WORKDIR}"

do_install() {
	if ${@bb.utils.contains('DISTRO_FEATURES','systemd','true','false',d)}; then
		install -d ${D}${sbindir}
		install -m 0755 ${WORKDIR}/ttt-ip-common.sh ${D}${sbindir}
		sed -i -e "s/^REF_ETH_INTERFACE=.*$/REF_ETH_INTERFACE=${DEFAULT_ETHERNET_MAIN_TSN_BRIDGE_INTERFACE}/" ${D}${sbindir}/ttt-ip-common.sh

		install -d ${D}${systemd_unitdir}/system ${D}${systemd_unitdir}/network
		install -m 0644 ${WORKDIR}/72-*.netdev ${D}${systemd_unitdir}/network
		install -m 0644 ${WORKDIR}/72-*.network ${D}${systemd_unitdir}/network
		install -m 0644 ${WORKDIR}/72-*.network.sample ${D}${systemd_unitdir}/network

		install -d ${D}${systemd_unitdir}/system
		install -m 0644 ${WORKDIR}/st-init-switch.service ${D}${systemd_unitdir}/system/
	fi
}
