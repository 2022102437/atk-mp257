SUMMARY = "ST SWITCH service for sysvinit"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/BSD-3-Clause;md5=550794465ba0ec5312d6919e203a55f9"
PR = "r2"

inherit update-rc.d

SRC_URI = " \
	file://ttt-ip-init-switch-sysvinit.sh \
	"

FILES:${PN} += "${systemd_unitdir} ${sysconfdir}"
ALLOW_EMPTY:${PN} = "1"
INITSCRIPT_NAME = "ttt-ip-init-switch-sysvinit.sh"
INITSCRIPT_PARAMS = "defaults 99 99"

S = "${WORKDIR}"

do_install() {
	install -d ${D}${sysconfdir}/init.d
	# switch
	install -m 0755 ${WORKDIR}/ttt-ip-init-switch-sysvinit.sh ${D}${sysconfdir}/init.d/ttt-ip-init-switch-sysvinit.sh
	sed -i -e "s/^REF_ETH_INTERFACE=.*$/REF_ETH_INTERFACE=${DEFAULT_ETHERNET_MAIN_TSN_BRIDGE_INTERFACE}/" ${D}${sysconfdir}/init.d/ttt-ip-init-switch-sysvinit.sh
}
