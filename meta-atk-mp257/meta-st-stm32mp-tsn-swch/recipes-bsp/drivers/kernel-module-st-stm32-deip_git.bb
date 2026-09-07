SUMMARY = "STM32 DEIP Kernel Driver Modules"
SECTION = "Glue modules"
HOMEPAGE = "http://www.st.com/"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"

DEPENDS = ""

inherit module

SRC_URI = "${TSN_SRC_URI}"
SRCREV = "${TSN_SRCREV}"

TTTECH_DIR = "st.stm32-deip"
S = "${WORKDIR}/git/${TTTECH_DIR}"

PV = "st-1.6.7"

EXTRA_OEMAKE += "KDIR='${STAGING_KERNEL_DIR}'"

do_create_runtime_spdx[depends] += "virtual/kernel:do_create_runtime_spdx"
