FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

DEPENDS:append:stm32mp25common = " dtbo-stm32mp25x-swch "
RDEPENDS:${PN}:append:stm32mp25common = " dtbo-stm32mp25x-swch "


UBOOT_EXTLINUX_TARGETS_EXTRA_CONFIG[stm32mp257f-ev1] += "stm32mp257f-ev1-tsn"
UBOOT_EXTLINUX_DEFAULT_LABEL:stm32mp257f-ev1-tsn = "stm32mp257f-ev1-tsn"
UBOOT_EXTLINUX_FDTOVERLAYS:stm32mp257f-ev1-tsn = "/devicetree/stm32mp25xx-ev1-swch.dtbo"
