FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://0001-Allow-running-in-background-with-STDIN-set-to-O_NONB.patch"
SRC_URI += "file://0002-gst-decoder.c-switch-to-decodebin3.patch"

PACKAGECONFIG = "gstreamer"
DEPENDS += "gstreamer1.0 gstreamer1.0-plugins-base"
