SUMMARY = "EDGE Kernel Driver Modules"
SECTION = "edge modules"
HOMEPAGE = "http://www.tttech.com/"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"

DEPENDS = ""

inherit module

SRC_URI = "${TSN_SRC_URI}"
SRCREV = "${TSN_SRCREV}"

TTTECH_DIR = "tsn_sw_base.edge-lkm"
S = "${WORKDIR}/git/${TTTECH_DIR}"

PV = "st-1.6.9-1"

SRC_URI += "\
    file://edgx_sw_modload.conf \
    file://edgx_sw_modprobe.conf \
"

do_install:append() {
    install -d ${D}${includedir}/${PN}
    install -m 0664 ${S}/edge.h ${D}${includedir}/${PN}

    install -d ${D}${sysconfdir}/modprobe.d/
    echo "options edgx_pfm_lkm netif=\"${DEFAULT_ETHERNET_MAIN_TSN_BRIDGE_INTERFACE}:0\"" > ${D}${sysconfdir}/modprobe.d/edgx_sw_core.conf
    install -m 0644 ${WORKDIR}/edgx_sw_modprobe.conf ${D}${sysconfdir}/modprobe.d/edgx_sw_modprobe.conf
    install -d ${D}${sysconfdir}/modules-load.d/
    install -m 0644 ${WORKDIR}/edgx_sw_modload.conf ${D}${sysconfdir}/modules-load.d/edgx_sw_modload.conf
}

MAKE_TARGETS = "sched=fsc sid=sid"

FILES_${PN}-dev += "${includedir}/${PN}/edge.h"
FILES:${PN} += "${sysconfdir}/"

do_create_runtime_spdx[depends] += "virtual/kernel:do_create_runtime_spdx"
