
include st-image-tsn-addons.inc

# tools
CORE_IMAGE_EXTRA_INSTALL += " \
    linuxptp \
    linuxptp-configs \
    iperf3 \
    iproute2-tc \
    iproute2-devlink \
    openssh-keygen \
    ebtables \
"

# kernel addons
CORE_IMAGE_EXTRA_INSTALL += " \
    kernel-module-edge \
    kernel-module-st-stm32-deip \
"

# tsn packages
CORE_IMAGE_EXTRA_INSTALL += " \
    ${TSN_PACKAGES} \
"

do_rootfs[depends] += " netopeer2-server-native:do_deploy"
