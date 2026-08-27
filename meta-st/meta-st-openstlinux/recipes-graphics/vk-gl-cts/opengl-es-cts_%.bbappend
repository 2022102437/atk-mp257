inherit python3native

PACKAGECONFIG = "${@bb.utils.filter('DISTRO_FEATURES', 'wayland', d)}"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

DEPENDS += "wayland-native"

CTSDIR = "/usr/local/${BPN}"
