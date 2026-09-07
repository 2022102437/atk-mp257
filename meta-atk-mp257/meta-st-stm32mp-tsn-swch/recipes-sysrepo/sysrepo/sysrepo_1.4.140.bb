# Recipe created by recipetool
SUMMARY = "YANG-based configuration and operational state data store for Unix/Linux applications."
DESCRIPTION = ""
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=e3fc50a88d0a364313df4b21ef20c29e"

SRC_URI = "git://github.com/sysrepo/sysrepo.git;protocol=https;nobranch=1 \
		file://common.h.in.patch \
		file://sysrepo.h.patch \
		file://sysrepo.c.patch \
		file://sysrepo-plugind.patch \
		file://sysrepo-add-avoid-deadlock-connection-flag.patch \
	"
SRCREV = "e3657e6c5aa49e2de45504450a06e1a21e2706b5"
PR = "r0"

S = "${WORKDIR}/git"

DEPENDS = "libyang protobuf protobuf-c protobuf-c-native libredblack libev libnetconf2"

FILES:${PN} += "/usr/share/yang/* /run/sysrepo*"

inherit cmake pkgconfig python3native python3-dir

# Specify any options you want to pass to cmake using EXTRA_OECMAKE:
EXTRA_OECMAKE = " -DCMAKE_INSTALL_PREFIX:PATH=/usr -DCMAKE_BUILD_TYPE:String=Release -DBUILD_EXAMPLES:String=False -DENABLE_TESTS:String=False -DREPOSITORY_LOC:PATH=/etc/sysrepo \
		  -DCALL_TARGET_BINS_DIRECTLY=False -DGEN_LANGUAGE_BINDINGS:String=False -DENABLE_NACM:String=True -DUSE_SR_MEM_MGMT:String=True "

EXTRA_OECMAKE:class-native = " -DCMAKE_INSTALL_PREFIX:PATH=${STAGING_INCDIR_NATIVE}/usr -DCMAKE_BUILD_TYPE:String=Release -DBUILD_EXAMPLES:String=False -DENABLE_TESTS:String=False -DREPOSITORY_LOC:PATH=${STAGING_INCDIR_NATIVE}/etc/sysrepo \
		  -DCALL_TARGET_BINS_DIRECTLY=False -DGEN_LANGUAGE_BINDINGS:String=False -DENABLE_NACM:String=True -DUSE_SR_MEM_MGMT:String=True "
EXTRA_OECMAKE:class-nativesdk = " -DCMAKE_INSTALL_PREFIX:PATH=${STAGING_INCDIR_NATIVE}/usr -DCMAKE_BUILD_TYPE:String=Release -DBUILD_EXAMPLES:String=False -DENABLE_TESTS:String=False -DREPOSITORY_LOC:PATH=${STAGING_INCDIR_NATIVE}/etc/sysrepo \
		  -DCALL_TARGET_BINS_DIRECTLY=False -DGEN_LANGUAGE_BINDINGS:String=False -DENABLE_NACM:String=True -DUSE_SR_MEM_MGMT:String=True "

BBCLASSEXTEND = "native nativesdk"
