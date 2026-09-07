FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

do_install:append() {
	#for TSN usage, usb otg need to be disabled
	rm ${D}${sysconfdir}/udev/rules.d/97-ustotg.rules
}
