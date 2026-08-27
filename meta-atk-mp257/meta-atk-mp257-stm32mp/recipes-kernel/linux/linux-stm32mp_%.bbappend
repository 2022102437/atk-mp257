# Alientek(正点原子) STM32MP257 board support for the ST kernel.
#
# Injects the Alientek board device trees into the kernel tree
# (arch/arm64/boot/dts/st/) and registers the base board dtb in the
# st/Makefile so that the dtb referenced by STM32MP_DT_FILES_EMMC is built.
#
# Drop any additional Alientek .dts/.dtsi files (e.g. other display variants)
# in recipes-kernel/linux/linux-stm32mp/ and add them to ALIENTEK_DTS_FILES.

FILESEXTRAPATHS:prepend := "${THISDIR}/linux-stm32mp:"

ALIENTEK_DTS_FILES = " \
    stm32mp257d-atk-ddr-2GB.dts \
    stm32mp257d-atk-ddr-2GB-ca35tdcid-resmem.dtsi \
    stm32mp257d-atk-ddr-2GB-lvds-1xSingleLink.dts \
    stm32mp257d-atk-ddr-2GB-lvds-2xSingleLink.dts \
    stm32mp257d-atk-ddr-2GB-lvds-dualLink.dts \
    stm32mp257d-atk-ddr-2GB-mipi.dts \
    stm32mp257d-atk-ddr-2GB-rgb.dts \
    stm32mp25-pinctrl-atk-ddr-2GB.dtsi \
"

# Base board devicetree name built by default
ALIENTEK_BASE_DTB = "stm32mp257d-atk-ddr-2GB"

SRC_URI:append:stm32mp257-atk = " ${@' '.join('file://%s' % f for f in '${ALIENTEK_DTS_FILES}'.split())}"

do_configure:prepend:stm32mp257-atk() {
    install -d ${S}/arch/arm64/boot/dts/st
    for f in ${ALIENTEK_DTS_FILES}; do
        install -m 0644 ${WORKDIR}/$f ${S}/arch/arm64/boot/dts/st/$f
    done
    if ! grep -q "${ALIENTEK_BASE_DTB}.dtb" ${S}/arch/arm64/boot/dts/st/Makefile; then
        echo "dtb-\$(CONFIG_ARCH_STM32) += ${ALIENTEK_BASE_DTB}.dtb" >> ${S}/arch/arm64/boot/dts/st/Makefile
    fi
}
