SUMMARY = "ST TSN service"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/BSD-3-Clause;md5=550794465ba0ec5312d6919e203a55f9"
PR = "r2"

inherit systemd

SRC_URI = " \
	file://ttt-ip-init-tsn-networkd-systemd.sh \
	file://st-tsn-networkd.service \
	"

FILES:${PN} += "${systemd_unitdir} ${sysconfdir}"
SYSTEMD_SERVICE:${PN} = "st-tsn-networkd.service"

S = "${WORKDIR}"

do_install() {
	if ${@bb.utils.contains('DISTRO_FEATURES','systemd','true','false',d)}; then
		install -d ${D}${systemd_unitdir}/system ${D}${sbindir}
		install -m 0644 ${WORKDIR}/st-tsn-networkd.service ${D}${systemd_unitdir}/system/
		install -m 0755 ${WORKDIR}/ttt-ip-init-tsn-networkd-systemd.sh ${D}${sbindir}
	fi
}
RDEPENDS:${PN} += "ttt-ip-switch"
