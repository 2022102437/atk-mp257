SUMMARY = "YANG data modelling language parser and toolkit"
DESCRIPTION = "libyang is YANG data modelling language parser and toolkit written (and providing API) in C. The library is used e.g. in libnetconf2, Netopeer2 or sysrepo projects."
SECTION = "libs"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENSE;md5=2982272c97a8e417a844857ca0d303b1"

SRC_URI = "git://github.com/CESNET/libyang.git;protocol=https;nobranch=1 \
	   file://CMakeLists.patch \
	   "
SRCREV = "e24ac91f03896008acc1664d4b3912fb6eea9a79"
PR = "r0"

S = "${WORKDIR}/git"

DEPENDS = "libpcre"

inherit cmake pkgconfig

# Specify any options you want to pass to cmake using EXTRA_OECMAKE:
EXTRA_OECMAKE = " -DCMAKE_INSTALL_PREFIX:PATH=/usr/ -DCMAKE_BUILD_TYPE:String=Release "
EXTRA_OECMAKE:class-native = " -DCMAKE_INSTALL_PREFIX:PATH=${STAGING_DIR_NATIVE}/usr/ -DCMAKE_BUILD_TYPE:String=Release "

BBCLASSEXTEND += "native nativesdk"

