SUMMARY = "Retry bringing up the ALIENTEK end0 Ethernet interface at boot"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = " file://end0-retry.service file://end0-retry.sh"

S = "${WORKDIR}/git"

inherit systemd

SYSTEMD_PACKAGES += " ${PN} "
SYSTEMD_SERVICE:${PN} = "end0-retry.service"
SYSTEMD_AUTO_ENABLE:${PN} = "enable"

do_install() {
    install -d ${D}${systemd_unitdir}/system ${D}${bindir}
    install -m 0644 ${WORKDIR}/end0-retry.service ${D}${systemd_unitdir}/system
    install -m 0755 ${WORKDIR}/end0-retry.sh ${D}${bindir}
}
