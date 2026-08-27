FILESEXTRAPATHS:prepend := "${THISDIR}/tf-m-stm32mp:"

LICENSE = "BSD-3-Clause & Apache-2.0"
LIC_FILES_CHKSUM = "file://license.rst;md5=07f368487da347f3c7bd0fc3085f3afa"

SRC_URI = "git://git.trustedfirmware.org/TF-M/trusted-firmware-m.git;protocol=https;nobranch=1;name=tfm"

# qcbor
SRC_URI:append = " git://github.com/laurencelundblade/QCBOR.git;protocol=https;branch=master;name=qcbor;destsuffix=${TF_M_EXTERNAL_SOURCES_ROOTDIR}/${TF_M_PATH_QCBOR}"
# mcuboot
SRC_URI:append = " gitsm://github.com/mcu-tools/mcuboot.git;protocol=https;branch=main;name=mcuboot;destsuffix=${TF_M_EXTERNAL_SOURCES_ROOTDIR}/${TF_M_PATH_MCUBOOT}"
# cmsis
SRC_URI:append = " git://github.com/ARM-software/CMSIS_6.git;protocol=https;nobranch=1;name=cmsis;destsuffix=${TF_M_EXTERNAL_SOURCES_ROOTDIR}/${TF_M_PATH_CMSIS}"
# cmsis core
SRC_URI:append = " git://github.com/STMicroelectronics/cmsis-core.git;protocol=https;name=cmsiscore;destsuffix=${TF_M_EXTERNAL_SOURCES_ROOTDIR}/${TF_M_PATH_STM32MP2_CMSIS_CORE};nobranch=1"
# mbedcrypto
SRC_URI:append = " gitsm://github.com/Mbed-TLS/mbedtls.git;protocol=https;nobranch=1;name=mbedtls;destsuffix=${TF_M_EXTERNAL_SOURCES_ROOTDIR}/${TF_M_PATH_MBEDCRYPTO}"
# ddr firmware
SRC_URI:append = " git://github.com/STMicroelectronics/stm32-ddr-phy-binary;protocol=https;branch=main;name=ddr-phy;destsuffix=${TF_M_EXTERNAL_SOURCES_ROOTDIR}/${TF_M_PATH_DDR_PHY_BIN_SRC}"

# psa-adac
SRC_URI:append = " gitsm://github.com/STMicroelectronics/psa-adac.git;protocol=https;name=psa-adac;destsuffix=${TF_M_EXTERNAL_SOURCES_ROOTDIR}/${TF_M_PATH_PSA_ADAC};nobranch=1"
# SCP-firmware
SRC_URI:append = " gitsm://github.com/STMicroelectronics/SCP-firmware.git;protocol=https;name=scp-firmware;destsuffix=${TF_M_EXTERNAL_SOURCES_ROOTDIR}/${TF_M_PATH_SCP_FW};nobranch=1"
# stm32mp2xx-hal-driver
SRC_URI:append = " git://github.com/STMicroelectronics/stm32mp2xx-hal-driver.git;protocol=https;name=stm32mp2haldriver;destsuffix=${TF_M_EXTERNAL_SOURCES_ROOTDIR}/${TF_M_PATH_STM32MP2_HAL_DRIVER};nobranch=1"
# cmsis-device-mp2
SRC_URI:append = " git://github.com/STMicroelectronics/cmsis-device-mp2.git;protocol=https;name=cmsisdevicemp2;destsuffix=${TF_M_EXTERNAL_SOURCES_ROOTDIR}/${TF_M_PATH_STM32MP2_CMSIS_DEVICE};nobranch=1"
# stm32mp2-low-power
SRC_URI:append = " git://github.com/STMicroelectronics/stm32mp2-low-power.git;protocol=https;name=mp2-low-power;destsuffix=${TF_M_EXTERNAL_SOURCES_ROOTDIR}/${TF_M_PATH_STM32MP2_LOW_POWER};nobranch=1"

# The required dependencies are documented in tf-m/config/config_base.cmake
# TF-Mv 2.1.4
SRCREV_tfm = "03d02d6feed02583c41acfe7147d1117678797a3"

TF_M_PATH_EXTERNAL = "external"
# qcbor
TF_M_PATH_QCBOR = "external/qcbor"
ARCHIVER_REVISION_QCBOR = "v1.2"
SRCREV_qcbor = "92d3f89030baff4af7be8396c563e6c8ef263622"
# mcuboot
TF_M_PATH_MCUBOOT = "external/mcuboot"
ARCHIVER_REVISION_MCUBOOT = "v2.1.0"
SRCREV_mcuboot = "9ee445ffca984174529f69a444d5aac9409ee191"
# cmsis v6.0.0
TF_M_PATH_CMSIS = "external/cmsis"
# Select v6.0.0 version plus few commits (no associated tag)
#ARCHIVER_REVISION_CMSIS = "v6.0.0"
ARCHIVER_REVISION_CMSIS = "d0c460c1697d210b49a4b90998195831c0cd325c"
SRCREV_cmsis = "d0c460c1697d210b49a4b90998195831c0cd325c"
# cmsis_core
TF_M_PATH_STM32MP2_CMSIS_CORE = "external/cmsis_core"
ARCHIVER_REVISION_STM32MP2_CMSIS_CORE = "v5.9.0"
SRCREV_cmsiscore = "1a2f783395dd72778a98ebe7771f36ca1c30a35e"
# mbedtls
TF_M_PATH_MBEDCRYPTO = "external/mbedtls"
ARCHIVER_REVISION_MBEDCRYPTO = "v3.6.5"
SRCREV_mbedtls = "e185d7fd85499c8ce5ca2a54f5cf8fe7dbe3f8df"
# ddr-phy
TF_M_PATH_DDR_PHY_BIN_SRC = "external/stm32-ddr-phy-binary"
ARCHIVER_REVISION_DDR_PHY_BIN_SRC = "v1.0-stm32mp"
SRCREV_ddr-phy = "77447cf214eadf128e487fcb10a4a78cd4ab6d56"
# psa-adac
TF_M_PATH_PSA_ADAC = "external/psa-adac"
ARCHIVER_REVISION_PSA_ADAC = "v1.0-stm32mp-r1"
SRCREV_psa-adac = "519a66d262882ead7069e308d9f9c24d62178393"
# scp-firmware
TF_M_PATH_SCP_FW = "external/scp-firmware"
ARCHIVER_REVISION_SCP_FW = "v2.13.0-stm32mp-r3.1"
SRCREV_scp-firmware = "35c0ea144a02c08ec30bb4deea40adc7ecbfe511"
# stm32mp2xx_hal_driver
TF_M_PATH_STM32MP2_HAL_DRIVER = "external/stm32mp2xx_hal_driver"
ARCHIVER_URL_STM32MP2_HAL_DRIVER = "https://github.com/STMicroelectronics/stm32mp2xx-hal-driver.git"
ARCHIVER_REVISION_STM32MP2_DRIVER = "v1.3.1"
SRCREV_stm32mp2haldriver = "a5e4d92ae2983d315b496fae282d22f6c30b4964"
# stm32mp2xx_cmsis_device
TF_M_PATH_STM32MP2_CMSIS_DEVICE = "external/cmsis_device_mp2"
ARCHIVER_URL_STM32MP2_CMSIS_DEVICE = "https://github.com/STMicroelectronics/cmsis-device-mp2.git"
ARCHIVER_REVISION_STM32MP2_CMSIS_DEVICE = "v1.3.1"
SRCREV_cmsisdevicemp2 = "dbda522fd850568d48e7ac2768825c4a23743302"

# stm32mp2-low-power
TF_M_PATH_STM32MP2_LOW_POWER = "external/stm32_lp_fw"
ARCHIVER_URL_MP2_LOW_POWER = "https://github.com/STMicroelectronics/stm32mp2-low-power/"
ARCHIVER_REVISION_MP2_LOW_POWER = "v1.1.0"
SRCREV_mp2-low-power = "4dec370354b45bc6f6badc118b418426bea1d98d"

SRCREV_FORMAT = "tfm"

UPSTREAM_CHECK_GITTAGREGEX = "^TF-Mv(?P<pver>\d+(\.\d+)+)$"

# ST Patches
SRC_URI += "\
    file://0001-v2.1.4-stm32mp-r2.1.patch.gz \
"

TF_M_VERSION = "2.1.4"
TF_M_SUBVERSION = "stm32mp"
TF_M_RELEASE = "r2.1"
PV = "v${TF_M_VERSION}-${TF_M_SUBVERSION}-${TF_M_RELEASE}"

#ARCHIVER_ST_BRANCH = "v${TF_M_VERSION}-${TF_M_SUBVERSION}"
ARCHIVER_ST_BRANCH = "v${TF_M_VERSION}-${TF_M_SUBVERSION}-w2544"
#ARCHIVER_ST_REVISION = "${PV}"
ARCHIVER_ST_REVISION = "v${TF_M_VERSION}-${TF_M_SUBVERSION}-r13"
ARCHIVER_COMMUNITY_BRANCH = "v${TF_M_VERSION}"
ARCHIVER_COMMUNITY_REVISION = "v${TF_M_VERSION}"

# In order to avoid issue with devtool and gitsm, we use dedicated folder not
# included inside tf-m source code.
# For archiver class, in order to extract all source code in a row, we configure
# tf-m extrenal source inside tf-m git source code
TF_M_EXTERNAL_SOURCES_ROOTDIR = "${@'git' if bb.data.inherits_class('archiver', d) and not bb.data.inherits_class('devtool-source', d) else 'tf-m-external-src'}"

# Configure TFM external sources
TF_M_EXTERNAL_SOURCES ??= "1"

# Don't let FetchContent download more sources during do_configure
TF_M_EXTERNAL_SOURCES_OECMAKE += "-DFETCHCONTENT_FULLY_DISCONNECTED=ON "
# Path to extra components
TF_M_EXTERNAL_SOURCES_OECMAKE += "-DQCBOR_PATH=${WORKDIR}/${TF_M_EXTERNAL_SOURCES_ROOTDIR}/${TF_M_PATH_QCBOR} "
TF_M_EXTERNAL_SOURCES_OECMAKE += "-DMCUBOOT_PATH=${WORKDIR}/${TF_M_EXTERNAL_SOURCES_ROOTDIR}/${TF_M_PATH_MCUBOOT} "
TF_M_EXTERNAL_SOURCES_OECMAKE += "-DCMSIS_PATH=${WORKDIR}/${TF_M_EXTERNAL_SOURCES_ROOTDIR}/${TF_M_PATH_CMSIS} "
TF_M_EXTERNAL_SOURCES_OECMAKE += "-DCMSIS_CORE_PATH=${WORKDIR}/${TF_M_EXTERNAL_SOURCES_ROOTDIR}/${TF_M_PATH_STM32MP2_CMSIS_CORE} "
TF_M_EXTERNAL_SOURCES_OECMAKE += "-DMBEDCRYPTO_PATH=${WORKDIR}/${TF_M_EXTERNAL_SOURCES_ROOTDIR}/${TF_M_PATH_MBEDCRYPTO} "
TF_M_EXTERNAL_SOURCES_OECMAKE += "-DDDR_PHY_BIN_SRC_PATH=${WORKDIR}/${TF_M_EXTERNAL_SOURCES_ROOTDIR}/${TF_M_PATH_DDR_PHY_BIN_SRC} "
TF_M_EXTERNAL_SOURCES_OECMAKE += "-DPLATFORM_PSA_ADAC_SOURCE_PATH=${WORKDIR}/${TF_M_EXTERNAL_SOURCES_ROOTDIR}/${TF_M_PATH_PSA_ADAC} "
TF_M_EXTERNAL_SOURCES_OECMAKE += "-DSCP_FW_PATH=${WORKDIR}/${TF_M_EXTERNAL_SOURCES_ROOTDIR}/${TF_M_PATH_SCP_FW} "
TF_M_EXTERNAL_SOURCES_OECMAKE += "-DSTM32MP2XX_HAL_DRIVER_PATH=${WORKDIR}/${TF_M_EXTERNAL_SOURCES_ROOTDIR}/${TF_M_PATH_STM32MP2_HAL_DRIVER} "
TF_M_EXTERNAL_SOURCES_OECMAKE += "-DCMSIS_DEVICE_MP2_PATH=${WORKDIR}/${TF_M_EXTERNAL_SOURCES_ROOTDIR}/${TF_M_PATH_STM32MP2_CMSIS_DEVICE} "
TF_M_EXTERNAL_SOURCES_OECMAKE += "-DSTM32MP2_LP_PATH=${WORKDIR}/${TF_M_EXTERNAL_SOURCES_ROOTDIR}/${TF_M_PATH_STM32MP2_LOW_POWER} "

EXTRA_OECMAKE += "${@bb.utils.contains('TF_M_EXTERNAL_SOURCES', '1', '${TF_M_EXTERNAL_SOURCES_OECMAKE}', '', d)}"


# ---------------------------------
# Configure devupstream class usage
# ---------------------------------
BBCLASSEXTEND = "devupstream:target"

SRC_URI:class-devupstream = "git://github.com/STMicroelectronics/trusted-firmware-m.git;protocol=https;nobranch=1"
SRCREV:class-devupstream = "4603997f315947feec89fc674b87b49a5d55655f"

# ---------------------------------
# Configure default preference to manage dynamic selection between tarball and github
# ---------------------------------
STM32MP_SOURCE_SELECTION ?= "tarball"

DEFAULT_PREFERENCE = "${@bb.utils.contains('STM32MP_SOURCE_SELECTION', 'github', '-1', '1', d)}"


# ---------------------------------
# Manage specifoc TF-M internal patches on external sources
# ---------------------------------
# Apply specific patches shipped within TF-M source code.
# Make sure to apply them in submodule to avoid failure with 'devtool modify'
apply_local_patches() {
    if [ "${TF_M_EXTERNAL_SOURCES}" = "1" ]; then
        cd ${WORKDIR}/${TF_M_EXTERNAL_SOURCES_ROOTDIR}/${TF_M_PATH_QCBOR}
        for fp in ${S}/lib/ext/qcbor/*.patch; do
            git am ${fp}
        done
        cd ${WORKDIR}/${TF_M_EXTERNAL_SOURCES_ROOTDIR}/${TF_M_PATH_MCUBOOT}
        if [ $(ls -1 ${S}/lib/ext/mcuboot/*.patch 2>/dev/null | wc -l) -gt 0 ]; then
            for fp in ${S}/lib/ext/mcuboot/*.patch; do
                git am ${fp}
            done
        fi
        cd ${WORKDIR}/${TF_M_EXTERNAL_SOURCES_ROOTDIR}/${TF_M_PATH_CMSIS}
        if [ $(ls -1 ${S}/lib/ext/cmsis/*.patch 2>/dev/null | wc -l) -gt 0 ]; then
            for fp in ${S}/lib/ext/cmsis/*.patch; do
                git am ${fp}
            done
        fi
        cd ${WORKDIR}/${TF_M_EXTERNAL_SOURCES_ROOTDIR}/${TF_M_PATH_MBEDCRYPTO}
        if [ $(ls -1 ${S}/lib/ext/mbedcrypto/*.patch 2>/dev/null | wc -l) -gt 0 ]; then
            for fp in ${S}/lib/ext/mbedcrypto/*.patch; do
                git am ${fp}
            done
        fi
        cd ${WORKDIR}/${TF_M_EXTERNAL_SOURCES_ROOTDIR}/${TF_M_PATH_STM32MP2_CMSIS_CORE}
        if [ ! -e ${WORKDIR}/${TF_M_EXTERNAL_SOURCES_ROOTDIR}/${TF_M_PATH_STM32MP2_CMSIS_CORE}/CMakeLists.txt ]; then
            if [ -e ${S}/platform/ext/target/stm/common/stm32mp2xx/lib/cmsis-core/CMakeLists.txt ]; then
                cp ${S}/platform/ext/target/stm/common/stm32mp2xx/lib/cmsis-core/CMakeLists.txt ${WORKDIR}/${TF_M_EXTERNAL_SOURCES_ROOTDIR}/${TF_M_PATH_STM32MP2_CMSIS_CORE}/
            fi
        fi
        cd ${WORKDIR}/${TF_M_EXTERNAL_SOURCES_ROOTDIR}/${TF_M_PATH_STM32MP2_CMSIS_DEVICE}
        if [ ! -e ${WORKDIR}/${TF_M_EXTERNAL_SOURCES_ROOTDIR}/${TF_M_PATH_STM32MP2_CMSIS_DEVICE}/CMakeLists.txt ]; then
            if [ -e ${S}/platform/ext/target/stm/common/stm32mp2xx/lib/cmsis-device-mp2/CMakeLists.txt ]; then
                cp ${S}/platform/ext/target/stm/common/stm32mp2xx/lib/cmsis-device-mp2/CMakeLists.txt ${WORKDIR}/${TF_M_EXTERNAL_SOURCES_ROOTDIR}/${TF_M_PATH_STM32MP2_CMSIS_DEVICE}/
            fi
        fi
        cd ${WORKDIR}/${TF_M_EXTERNAL_SOURCES_ROOTDIR}/${TF_M_PATH_STM32MP2_HAL_DRIVER}
        if [ ! -e ${WORKDIR}/${TF_M_EXTERNAL_SOURCES_ROOTDIR}/${TF_M_PATH_STM32MP2_HAL_DRIVER}/CMakeLists.txt ]; then
            if [ -e ${S}/platform/ext/target/stm/common/stm32mp2xx/lib/stm32mp2xx-hal-driver/CMakeLists.txt ]; then
                cp ${S}/platform/ext/target/stm/common/stm32mp2xx/lib/stm32mp2xx-hal-driver/CMakeLists.txt ${WORKDIR}/${TF_M_EXTERNAL_SOURCES_ROOTDIR}/${TF_M_PATH_STM32MP2_HAL_DRIVER}/
            fi
        fi
        cd -
    fi
}
do_patch:append() {
    bb.build.exec_func('apply_local_patches', d)
}
# The use of devtool deletes do_patch task, breaking the launch of 'apply_local_patches' task
# Overcome this by adding 'apply_local_patches' task to do_configure prefunc
do_configure[prefuncs] += "${@["", "apply_local_patches"][(d.getVar('EXTERNALSRC') or '') != '']}"
