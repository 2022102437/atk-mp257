SUMMARY = "ST Initialisation for TSN purpose with st specific action"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/BSD-3-Clause;md5=550794465ba0ec5312d6919e203a55f9"
PR = "r2"

inherit systemd

SRC_URI = " \
	file://st-specific_action-tsn-systemd.sh \
	file://st-specific_action-tsn-sysvinit.sh \
	\
	file://st-specific_macaddress.sh \
	"

FILES:${PN} += "${systemd_unitdir} ${sysconfdir}"

S = "${WORKDIR}"

do_install() {
	install -d ${D}${bindir}
	if ${@bb.utils.contains('DISTRO_FEATURES','systemd','true','false',d)}; then
		install -m 0755 ${WORKDIR}/st-specific_action-tsn-systemd.sh ${D}${bindir}/st-specific_action-tsn.sh
	else
		install -m 0755 ${WORKDIR}/st-specific_action-tsn-sysvinit.sh ${D}${bindir}/st-specific_action-tsn.sh
	fi
	install -m 0755 ${WORKDIR}/st-specific_macaddress.sh ${D}${bindir}/
}
