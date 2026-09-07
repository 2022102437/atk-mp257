SUMMARY = "DE-PTP from TTTECH"
LICENSE = "TTTECH-license"

SRC_URI = "\
    ${TSN_SRC_URI} \
    file://deptp.service \
    file://ptp_config.xml \
    "
SRCREV = "${TSN_SRCREV}"

PV = "st-1.6.9-2.5.4-${TTTECH_BINARY_DATE}"

TTTECH_DIR = "de-ptp/aarch64"
S = "${WORKDIR}/git/${TTTECH_DIR}"
# ------------------------------------------------------------------
TTTECH_BINARY_ARCH = "aarch64"
TTTECH_BINARY_DATE = "2026-06-30"
TTTECH_BINARY_TARBALL = "TTTECH-de-ptp-${TTTECH_BINARY_ARCH}-${TTTECH_BINARY_DATE}"
TTTECH_BINARIES_PATH = "${WORKDIR}/git/de-ptp"
inherit binaries-unpack

# ------------------------------------------------------------------
# ------------------------------------------------------------------

inherit systemd bash-completion update-rc.d bin_package

INITSCRIPT_NAME = "deptp"
# INITSCRIPT_PARAMS = "defaults 90 20"
# disable daemon at startup
INITSCRIPT_PARAMS = "stop 20 0 1 6 ."

SYSTEMD_SERVICE:${PN} = "deptp.service"
SYSTEMD_AUTO_ENABLE:${PN} = "disable"

do_install:append() {
    if ${@bb.utils.contains('DISTRO_FEATURES','systemd','true','false',d)}; then
        install -d ${D}${systemd_unitdir}/system
        install -m 644 ${TSN_BASE_LAYER}/recipes-de-ptp/de-ptp/files/deptp.service ${D}${systemd_unitdir}/system/
    fi
    install -m 644 ${TSN_BASE_LAYER}/recipes-de-ptp/de-ptp/files/ptp_config.xml ${D}${sysconfdir}/deptp/
    rm ${D}/TTTECH_license.txt
}

RDEPENDS:${PN} = "${@bb.utils.contains('DISTRO_FEATURES','sysvinit','initscripts','',d)}"
CONFFILES:${PN} += "${sysconfdir}/init.d/deptp"

RPROVIDES:${PN} = "libclock_if.so libclock_if.so.0 libpacket_if.so libpacket_if.so.0 libhost_clock_adj.so libhost_clock_adj.so.0"

# This gets rid of new qa error
TARGET_CC_ARCH += "${LDFLAGS}"
