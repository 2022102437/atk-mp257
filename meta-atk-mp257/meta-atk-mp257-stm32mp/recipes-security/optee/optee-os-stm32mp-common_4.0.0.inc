FILESEXTRAPATHS:prepend := "${THISDIR}/optee-os-stm32mp:"

LICENSE = "BSD-2-Clause & BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENSE;md5=c1f21c4f72f372ef38a5a4aee55ec173"

SRC_URI = "git://github.com/OP-TEE/optee_os.git;protocol=https;branch=master"
SRCREV = "2a5b1d1232f582056184367fb58a425ac7478ec6"

SRC_URI += " \
    file://fonts.tar.gz;subdir=git;name=fonts \
    file://0001-4.0.0-stm32mp-r3.1.patch \
    "

SRC_URI[fonts.sha256sum] = "4941e8bb6d8ac377838e27b214bf43008c496a24a8f897e0b06433988cbd53b2"

OPTEE_VERSION = "4.0.0"
OPTEE_SUBVERSION = "stm32mp"
OPTEE_RELEASE = "r3.1"

PV = "${OPTEE_VERSION}-${OPTEE_SUBVERSION}-${OPTEE_RELEASE}"

ARCHIVER_ST_BRANCH = "${OPTEE_VERSION}-${OPTEE_SUBVERSION}"
ARCHIVER_ST_REVISION = "${PV}"
ARCHIVER_COMMUNITY_BRANCH = "master"
ARCHIVER_COMMUNITY_REVISION = "${OPTEE_VERSION}"

S = "${WORKDIR}/git"

# ---------------------------------
# Configure devupstream class usage
# ---------------------------------
BBCLASSEXTEND = "devupstream:target"

SRC_URI:class-devupstream = "git://github.com/STMicroelectronics/optee_os.git;protocol=https;branch=${ARCHIVER_ST_BRANCH}"
SRCREV:class-devupstream = "0063536697f1d5337e80d43507c9887e49e36b43"

# ---------------------------------
# Configure default preference to manage dynamic selection between tarball and github
# ---------------------------------
STM32MP_SOURCE_SELECTION ?= "tarball"

DEFAULT_PREFERENCE = "${@bb.utils.contains('STM32MP_SOURCE_SELECTION', 'github', '-1', '1', d)}"
