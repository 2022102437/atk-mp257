# Alientek(正点原子) STM32MP257 board external device trees.
#
# Injects the Alientek boot-chain device trees into the external-dt repository
# (dt-stm32mp.git) so that TF-A / U-Boot / OP-TEE pick them up through
# TFA_EXTERNAL_DT / EXT_DTS / CFG_EXT_DTS when building for MACHINE
# stm32mp257-atk.
#
# Source files live in:
#   recipes-extended/external-dt/external-dt/{tf-a,u-boot,optee}/
#   (as staged from the Alientek SDK: tf-a-2.10-v1.0 / uboot-2023.10-v1.1 /
#    optee-4.0-v1.0)
#
# NOTE: MACHINE must select the kernel dts name "stm32mp257d-atk-ddr-2GB" via
# STM32MP_DT_FILES_EMMC so that TF-A/OP-TEE FIP and U-Boot extlinux use the
# matching board dtb.

FILESEXTRAPATHS:prepend := "${THISDIR}/external-dt:"

# The Alientek board files are fetched as file:// entries (git fetcher would
# not see them otherwise). Subdir keeps them separated from the dt-stm32mp.git
# checkout in WORKDIR.
ATK_EXTDT_DIR = "stm32mp2/a35-td"

ATK_EXTDT_TFA_FILES = " \
    stm32mp257d-atk-ddr-2GB.dts \
    stm32mp257d-atk-ddr-2GB-fw-config.dts \
    stm32mp257d-atk-ddr-2GB-ca35tdcid-fw-config.dtsi \
    stm32mp257d-atk-ddr-2GB-ca35tdcid-rcc.dtsi \
    stm32mp25-ddr4-2x8Gbits-2x16bits-1200MHz-atk.dtsi \
    stm32mp25-pinctrl-atk-ddr-2GB.dtsi \
"
ATK_EXTDT_UBOOT_FILES = " \
    stm32mp257d-atk-ddr-2GB.dts \
    stm32mp257d-atk-ddr-2GB-u-boot.dtsi \
    stm32mp257d-atk-ddr-2GB-ca35tdcid-resmem.dtsi \
    stm32mp25-pinctrl-atk-ddr-2GB.dtsi \
"
ATK_EXTDT_OPTEE_FILES = " \
    stm32mp257d-atk-ddr-2GB.dts \
    stm32mp257d-atk-ddr-2GB-ca35tdcid-rcc.dtsi \
    stm32mp257d-atk-ddr-2GB-ca35tdcid-resmem.dtsi \
    stm32mp257d-atk-ddr-2GB-ca35tdcid-rif.dtsi \
    stm32mp25-pinctrl-atk-ddr-2GB.dtsi \
"

SRC_URI:append:stm32mp257-atk = " \
    file://tf-a/stm32mp257d-atk-ddr-2GB.dts \
    file://tf-a/stm32mp257d-atk-ddr-2GB-fw-config.dts \
    file://tf-a/stm32mp257d-atk-ddr-2GB-ca35tdcid-fw-config.dtsi \
    file://tf-a/stm32mp257d-atk-ddr-2GB-ca35tdcid-rcc.dtsi \
    file://tf-a/stm32mp25-ddr4-2x8Gbits-2x16bits-1200MHz-atk.dtsi \
    file://tf-a/stm32mp25-pinctrl-atk-ddr-2GB.dtsi \
    file://u-boot/stm32mp257d-atk-ddr-2GB.dts \
    file://u-boot/stm32mp257d-atk-ddr-2GB-u-boot.dtsi \
    file://u-boot/stm32mp257d-atk-ddr-2GB-ca35tdcid-resmem.dtsi \
    file://u-boot/stm32mp25-pinctrl-atk-ddr-2GB.dtsi \
    file://optee/stm32mp257d-atk-ddr-2GB.dts \
    file://optee/stm32mp257d-atk-ddr-2GB-ca35tdcid-rcc.dtsi \
    file://optee/stm32mp257d-atk-ddr-2GB-ca35tdcid-resmem.dtsi \
    file://optee/stm32mp257d-atk-ddr-2GB-ca35tdcid-rif.dtsi \
    file://optee/stm32mp25-pinctrl-atk-ddr-2GB.dtsi \
"

# Alientek boot device tree base name
ATK_BOARD_DT = "stm32mp257d-atk-ddr-2GB"

do_configure:prepend:stm32mp257-atk() {
    extdt_base="${STAGING_EXTDT_DIR}/${ATK_EXTDT_DIR}"
    install -d ${extdt_base}/tf-a ${extdt_base}/u-boot ${extdt_base}/optee

    # TF-A
    for f in ${ATK_EXTDT_TFA_FILES}; do
        install -m 0644 ${WORKDIR}/tf-a/$f ${extdt_base}/tf-a/$f
    done

    # U-Boot (also register the dtb in the external-dt u-boot Makefile)
    for f in ${ATK_EXTDT_UBOOT_FILES}; do
        install -m 0644 ${WORKDIR}/u-boot/$f ${extdt_base}/u-boot/$f
    done
    if ! grep -q "${ATK_BOARD_DT}.dtb" ${extdt_base}/u-boot/Makefile; then
        sed -i "s|\tstm32mp257f-dk-ca35tdcid-ostl.dtb \\\\|\tstm32mp257f-dk-ca35tdcid-ostl.dtb \\\\\n\t${ATK_BOARD_DT}.dtb \\\\|" ${extdt_base}/u-boot/Makefile
    fi

    # OP-TEE (also register the dts in the external-dt optee conf.mk)
    for f in ${ATK_EXTDT_OPTEE_FILES}; do
        install -m 0644 ${WORKDIR}/optee/$f ${extdt_base}/optee/$f
    done
    if ! grep -q "257D_ATK_DDR_2GB" ${extdt_base}/optee/conf.mk; then
        echo "flavor_dts_file-257D_ATK_DDR_2GB = stm32mp257d-atk-ddr-2GB.dts" >> ${extdt_base}/optee/conf.mk
        echo "flavorlist-MP25 += \$(flavor_dts_file-257D_ATK_DDR_2GB)" >> ${extdt_base}/optee/conf.mk
    fi
}
