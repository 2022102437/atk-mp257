SUMMARY = "Library for accessing system data for YANG modules"
SECTION = "tsn-base"
LICENSE = "TTTECH-license"

INHIBIT_PACKAGE_STRIP = "1"

SRC_URI = "${TSN_SRC_URI}"
SRCREV = "${TSN_SRCREV}"

PV = "st-1.6.9"

TTTECH_DIR = "tsn_sw_base.netopeer-modules/${TTTECH_BINARY_ARCH}"
S = "${WORKDIR}/git/${TTTECH_DIR}"

DEPENDS = "coreutils-native"

# ------------------------------------------------------------------
TTTECH_BINARY_ARCH = "aarch64"
TTTECH_BINARY_DATE = "2026-06-30"
TTTECH_BINARY_TARBALL = "TTTECH-libbase-${TTTECH_BINARY_ARCH}-${TTTECH_BINARY_DATE}"
TTTECH_BINARIES_PATH = "${WORKDIR}/git/tsn_sw_base.netopeer-modules"
inherit binaries-unpack


EXTRA_OEMAKE = "-e -j 1 CCFLAGS='${CFLAGS} -fPIC -D_GNU_SOURCE -I${S}/include -DVER_FULL=\"1.0\"'"

inherit bin_package

do_install:append() {
    rm ${D}/TTTECH_license.txt
}
FILES:${PN} = "${libdir}/lib*.so.*"

FILES:${PN}-dev += " ${includedir}/libbase/*"

RDEPENDS:${PN}-staticdev = ""
RDEPENDS:${PN}-dev = ""
RDEPENDS:${PN}-dbg = ""
RDEPENDS:${PN} = ""
RDEPENDS:${PN}-doc = ""
RDEPENDS:${PN}-locale = ""
RDEPENDS:${PN}-static = ""

PROVIDES = "libbase"

RPROVIDES:${PN} = "libbase.so libbase.so.1"
RPROVIDES:${PN}-staticdev = "libbase.a"

SKIP_FILEDEPS:${PN} = "1"
SKIP_FILEDEPS:${PN}-staticdev = "1"
SKIP_FILEDEPS:${PN}-dev = "1"
SKIP_FILEDEPS:${PN}-dbg = "1"
SKIP_FILEDEPS:${PN}-doc = "1"
SKIP_FILEDEPS:${PN}-locale = "1"
SKIP_FILEDEPS:${PN}-static = "1"

LEAD_SONAME = "libbase.so"

# This gets rid of new qa error
TARGET_CC_ARCH += "${LDFLAGS}"
