SUMMARY = "libnetconf2 is a NETCONF library in C intended for building NETCONF clients and servers"
DESCRIPTION = "The library provides functions to connect NETCONF client and server to each other via SSH and to send, receive and process NETCONF messages."
SECTION = "libs"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENSE;md5=08a5578c9bab06fb2ae84284630b973f"

SRC_URI = "git://github.com/CESNET/libnetconf2.git;protocol=https;nobranch=1"

SRCREV = "c3fd42c6e3fd4cb0cbe6a10ee729b4566cfcb556"
PR = "r0"

S = "${WORKDIR}/git"

DEPENDS = "libssh libssh-native openssl libyang libyang-native openssl-native libxcrypt"

inherit cmake pkgconfig

# Specify any options you want to pass to cmake using EXTRA_OECMAKE:
EXTRA_OECMAKE = " -DCMAKE_INSTALL_PREFIX:PATH=${prefix} -DCMAKE_BUILD_TYPE:String=Release -DLIBYANG_INCLUDE_DIR:PATH=${STAGING_INCDIR}/ -DLIBYANG_LIBRARY:PATH=${STAGING_LIBDIR}/ -DENABLE_TLS:String=ON"
EXTRA_OECMAKE:class-native = " -DCMAKE_INSTALL_PREFIX:PATH=${prefix} -DCMAKE_BUILD_TYPE:String=Release -DLIBYANG_INCLUDE_DIR:PATH=${STAGING_INCDIR_NATIVE} -DLIBYANG_LIBRARY:PATH=${STAGING_LIBDIR_NATIVE} -DENABLE_TLS:String=ON"

BBCLASSEXTEND = "native nativesdk"
