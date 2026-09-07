SUMMARY = "ieee-8021-bridge-mib"
SECTION = "tsn-base"
LICENSE = "TTTECH-license"

DEPENDS = "libbase libtsn net-snmp libpcre libnl"

SRC_URI = "\
    ${TSN_SRC_URI} \
    "
SRCREV = "${TSN_SRCREV}"

TTTECH_DIR = "tsn_sw_base.net-snmp-mibs/${TTTECH_BINARY_ARCH}"
S = "${WORKDIR}/git/${TTTECH_DIR}"

PV = "st-1.6.9"

# ------------------------------------------------------------------
TTTECH_BINARY_ARCH = "aarch64"
TTTECH_BINARY_DATE = "2026-06-30"
TTTECH_BINARY_TARBALL = "TTTECH-snmp-mibs-${TTTECH_BINARY_ARCH}-${TTTECH_BINARY_DATE}"
TTTECH_BINARIES_PATH = "${WORKDIR}/git/tsn_sw_base.net-snmp-mibs"
inherit binaries-unpack

FILES:${PN} += "${libdir}/ieee8021BridgeMib.so ${datadir}/snmp/mibs/IEEE8021-TC-MIB ${datadir}/snmp/mibs/IEEE8021-BRIDGE-MIB"

# Needed to update dynamic library name in elf file
DEPENDS += "patchelf-native"
do_install() {
    install -d ${D}/${libdir}
    install -m 0755 ${S}/${libdir}/ieee8021BridgeMib.so ${D}/${libdir}

    install -d ${D}/${datadir}/snmp/mibs
    install -m 0644 ${S}/usr/share/snmp/mibs/IEEE8021-BRIDGE-MIB  ${D}/${datadir}/snmp/mibs/
    install -m 0644 ${S}/usr/share/snmp/mibs/IEEE8021-TC-MIB  ${D}/${datadir}/snmp/mibs/

    #patch issue with libbase.so and libtsn
    #patchelf --replace-needed libbase.so libbase.so.1 ${D}${libdir}/ieee8021BridgeMib.so
    #patchelf --replace-needed libtsn.so libtsn.so.2 ${D}${libdir}/ieee8021BridgeMib.so
}
