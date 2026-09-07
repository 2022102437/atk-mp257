DESCRIPTION = "Device tree for stm32mp25x ethernet switch "
HOMEPAGE = "www.st.com"

SRC_URI = " file://stm32mp25xx-ev1-swch.dts "

COMPATIBLE_MACHINE = "(stm32mp25common)"

inherit devicetree
PROVIDES:remove = "virtual/dtb"

