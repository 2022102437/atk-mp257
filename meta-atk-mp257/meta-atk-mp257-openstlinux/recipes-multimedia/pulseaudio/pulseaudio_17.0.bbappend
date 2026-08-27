FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

PACKAGECONFIG ?= "${@bb.utils.contains('DISTRO_FEATURES', 'bluetooth', 'bluez5', '', d)} \
                   ${@bb.utils.contains('DISTRO_FEATURES', 'zeroconf', 'avahi', '', d)} \
                   ${@bb.utils.contains('DISTRO_FEATURES', '3g', 'ofono', '', d)} \
                   ${@bb.utils.filter('DISTRO_FEATURES', 'ipv6 systemd x11', d)} \
                   dbus gsettings \
                   "

# Pulse audio configuration files
SRC_URI += "file://pulse_profile.sh \
            "

# Pulse audio configuration files installation
do_install:append() {
    install -d ${D}${sysconfdir}/profile.d
    install -m 0644 ${WORKDIR}/pulse_profile.sh ${D}${sysconfdir}/profile.d/
}

PACKAGES =+ "${PN}-profile ${PN}-tools"
FILES:${PN}-profile += "/etc/profile.d"
FILES:${PN}-server:remove = "${bindir}/pactl"
FILES:${PN}-tools = "${bindir}/pactl"
RDEPENDS:pulseaudio-server += "${PN}-tools"
