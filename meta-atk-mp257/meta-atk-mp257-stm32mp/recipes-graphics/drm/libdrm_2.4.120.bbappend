FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}/:"

# We don't want etnaviv drm package
PACKAGECONFIG:stm32mpcommon = "install-test-programs tests"

PACKAGE_ARCH:stm32mpcommon = "${MACHINE_ARCH}"

SRC_URI:append:stm32mpcommon = " \
        file://0001-tests-util-smtpe-increase-alpha-to-middle-band.patch \
        file://0002-tests-modetest-set-property-in-atomic-mode.patch \
        file://0003-tests-modetest-close-crtc.patch \
        "
