FILESEXTRAPATHS:prepend := "${THISDIR}/files-atk-openamp-eval:"

# ST ships Yocto CMake build scaffolding only for the MP21 (STM32MP215F-DK)
# OpenAMP_TTY_echo project. The MP257 EV1 OpenAMP_TTY_echo is CubeIDE-only,
# so inject the same CMake build files (ported for STM32MP257) into it.
# This lets the m33projects-stm32mp2 recipe build the MP257 EV1 OpenAMP
# example into an ELF installable on this board (A35 side of the A35<->M33
# OpenAMP link: firmware is loaded/started via the kernel remoteproc).
SRC_URI:append = " \
    file://openamp-eval-CMakeLists.txt \
    file://openamp-eval-syscalls.c \
    file://util/arm-gcc-toolchain.cmake \
    file://util/color.cmake \
    file://util/cortex-m33-stm32mp2.cmake \
    file://util/utils.cmake \
"

do_configure:prepend() {
    ev1_openamp_dir="${S}/Projects/STM32MP257F-EV1/Applications/OpenAMP/OpenAMP_TTY_echo"
    install -m 0644 ${WORKDIR}/openamp-eval-CMakeLists.txt ${ev1_openamp_dir}/CMakeLists.txt
    install -m 0644 ${WORKDIR}/openamp-eval-syscalls.c ${ev1_openamp_dir}/CM33/NonSecure/Core/Src/syscalls.c
    install -d ${ev1_openamp_dir}/util
    install -m 0644 ${WORKDIR}/util/*.cmake ${ev1_openamp_dir}/util/
}

# M33 is started manually by the developer: do NOT install the st-m33firmware-load
# autostart systemd service nor any default.$board marker file.
SYSTEMD_AUTO_ENABLE:${PN} = "disable"
