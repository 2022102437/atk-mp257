FILESEXTRAPATHS:prepend := "${THISDIR}/patches:"

SRC_URI += " \
    file://0001-mstpd_flush.patch \
    file://0002-mstpd_libtsn_integ.patch \
    file://0003-mstp_more_nodes.patch \
    file://0004-mstp_maxhops.patch \
    file://0005-te_msti.patch \
    file://0006-drop_support_for_STP.patch \
    file://mstpd_tttech_deip.c \
    file://mstp_tsn.h \
    file://mstp_tsn_private.h \
    "

#disable strionop-truncation warning for mstpd
EXTRA_OEMAKE += " CFLAGS='${CFLAGS} -fPIC -Wno-stringop-truncation' "

DEPENDS += "coreutils-native"
RDEPENDS:${PN} += " python3-core "

do_configure:append() {
  cp ${WORKDIR}/mstpd_tttech_deip.c ${S}/driver_deps.c
  cp ${WORKDIR}/mstp_tsn.h ${S}/mstp_tsn.h
  cp ${WORKDIR}/mstp_tsn_private.h ${S}/mstp_tsn_private.h
  # Update interpreter if ifquery does not yet use python3
  sed -i 's#\(^\#!/usr/bin/python\)$#\13#' ${S}/utils/ifquery
  ${STAGING_BINDIR_NATIVE}/sync
}

# disable start of service by default
SYSTEMD_AUTO_ENABLE:${PN} = "disable"
INITSCRIPT_PARAMS = "stop 20 0 1 6 ."
