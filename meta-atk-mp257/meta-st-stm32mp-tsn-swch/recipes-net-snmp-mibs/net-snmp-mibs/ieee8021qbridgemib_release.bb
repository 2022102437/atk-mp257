SUMMARY = "ieee8021QBridgeMib"
SECTION = "tsn-base"
LICENSE = "TTTECH-license"

DEPENDS = "libbase libtsn net-snmp libpcre libnl"

SRC_URI = "\
    ${TSN_SRC_URI} \
    "
SRCREV = "${TSN_SRCREV}"

PV = "st-1.6.9"

TTTECH_DIR = "tsn_sw_base.net-snmp-mibs/${TTTECH_BINARY_ARCH}"
S = "${WORKDIR}/git/${TTTECH_DIR}"

# ------------------------------------------------------------------
TTTECH_BINARY_ARCH = "aarch64"
TTTECH_BINARY_DATE = "2026-06-30"
TTTECH_BINARY_TARBALL = "TTTECH-snmp-mibs-${TTTECH_BINARY_ARCH}-${TTTECH_BINARY_DATE}"
TTTECH_BINARIES_PATH = "${WORKDIR}/git/tsn_sw_base.net-snmp-mibs"
inherit binaries-unpack


FILES:${PN} += "${libdir}/ieee8021QBridgeMib.so ${datadir}/snmp/mibs/*MIB*"

do_install() {
    install -d ${D}/${libdir}
    install -m 0755 ${S}/${libdir}/ieee8021QBridgeMib.so ${D}/${libdir}

    install -d ${D}/${datadir}/snmp/mibs
    install -m 644 ${S}/usr/share/snmp/mibs/IEEE8021-Q-BRIDGE-MIB  ${D}/${datadir}/snmp/mibs/
    install -m 644 ${S}/usr/share/snmp/mibs/P-BRIDGE-MIB ${D}/${datadir}/snmp/mibs/
    install -m 644 ${S}/usr/share/snmp/mibs/Q-BRIDGE-MIB ${D}/${datadir}/snmp/mibs/
    install -m 644 ${S}/usr/share/snmp/mibs/RMON2-MIB ${D}/${datadir}/snmp/mibs/
    install -m 644 ${S}/usr/share/snmp/mibs/TOKEN-RING-RMON-MIB ${D}/${datadir}/snmp/mibs/
}

# It looks like having upper case letters in packages breaks Yocto and it complains about libc rdepends
INSANE_SKIP:${PN} += "dep-cmp build-deps file-rdeps pkgvarcheck"
