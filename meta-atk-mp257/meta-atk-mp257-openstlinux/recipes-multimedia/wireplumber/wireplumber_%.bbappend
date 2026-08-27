FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "  \
    file://50-alsa-config.conf \
    file://11-bluetooth-monitor.conf \
"


do_install:append() {
    # create directory for system-wide wireplumber configuration
    install -d "${D}${sysconfdir}/wireplumber/wireplumber.conf.d"

    install -m 0644 "${WORKDIR}/50-alsa-config.conf" "${D}${sysconfdir}/wireplumber/wireplumber.conf.d"
    install -m 0644 "${WORKDIR}/11-bluetooth-monitor.conf" "${D}${sysconfdir}/wireplumber/wireplumber.conf.d"
}

FILES:${PN} += " \
    ${sysconfdir}/wireplumber \
"
