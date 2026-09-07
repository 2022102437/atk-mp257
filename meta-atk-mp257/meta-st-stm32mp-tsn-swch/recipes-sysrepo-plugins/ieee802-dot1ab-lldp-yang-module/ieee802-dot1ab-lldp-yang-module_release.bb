SUMMARY = "Netopeer2 is a set of tools implementing network configuration tools based on the NETCONF Protocol."
DESCRIPTION = "Netopeer2 is based on the new generation of the NETCONF and YANG libraries - libyang and libnetconf2. The Netopeer server uses sysrepo as a NETCONF datastore implementation."
LICENSE = "TTTECH-license"

SRC_URI = "${TSN_SRC_URI}"
SRCREV = "${TSN_SRCREV}"

TTTECH_DIR = "tsn_sw_base.sysrepo-plugins/${TTTECH_BINARY_ARCH}"
S = "${WORKDIR}/git/${TTTECH_DIR}"

PV = "st-1.6.9"

# ------------------------------------------------------------------
TTTECH_BINARY_ARCH = "aarch64"
TTTECH_BINARY_DATE = "2026-06-30"
TTTECH_BINARY_TARBALL = "TTTECH-sysrepo-plugins-${TTTECH_BINARY_ARCH}-${TTTECH_BINARY_DATE}"
TTTECH_BINARIES_PATH = "${WORKDIR}/git/tsn_sw_base.sysrepo-plugins"
inherit binaries-unpack

DEPENDS = "libbase lldpd libyang libnetconf2 sysrepo coreutils openssh openssl openssh-native libbsd"

FILES:${PN} += "${libdir}/sysrepo/* ${sysconfdir}/netopeer2/*"


do_install () {
    install -d ${D}/${sysconfdir}/netopeer2/yang ${D}/${libdir}/sysrepo/plugins/
    # yang modules
    install -m 0644 ${S}/${sysconfdir}/netopeer2/yang/ieee802-dot1ab-lldp.yang ${D}/${sysconfdir}/netopeer2/yang
    install -m 0644 ${S}/${sysconfdir}/netopeer2/yang/ieee802-dot1ab-types.yang ${D}/${sysconfdir}/netopeer2/yang
    install -m 0644 ${S}/${sysconfdir}/netopeer2/yang/ieee802-dot1q-types.yang ${D}/${sysconfdir}/netopeer2/yang
    install -m 0644 ${S}/${sysconfdir}/netopeer2/yang/ietf-routing.yang ${D}/${sysconfdir}/netopeer2/yang
    # library
    install -m 0644 ${S}/${libdir}/sysrepo/plugins/libieee802-dot1ab-lldp-yang-module.so ${D}/${libdir}/sysrepo/plugins/

    if [ "${libdir}" != "/usr/lib" ];
    then
        if [ -d ${D}/usr/lib ]; then
            mv ${D}/usr/lib ${D}/usr/lib64
        fi
    fi
}

