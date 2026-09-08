require recipes-st/images/st-image-weston.bb

inherit populate_sdk_qt6 features_check

# need to have wayland feature
REQUIRED_DISTRO_FEATURES = "wayland"

SUMMARY = "ALIENTEK STM32MP257 minimal Qt6 image (Qt Framework GUI dev, based on weston image)"

STM32MP_USERFS_IMAGE = "${IMAGE_BASENAME}"

# Define ROOTFS_MAXSIZE to 3GB
IMAGE_ROOTFS_MAXSIZE = "3145728"

# Define the size of userfs
STM32MP_USERFS_SIZE = "307200"

#
# Minimal Qt6 runtime set (wayland platform), keep it lean on purpose.
# Add more Qt modules (qtmultimedia, qtcharts, qtquick3d, ...) as needed.
#
IMAGE_QT_MIN = " \
    qtbase \
    qtbase-plugins \
    qtbase-tools \
    qtwayland \
    qtwayland-plugins \
    qtwayland-qmlplugins \
    qtdeclarative \
    qtdeclarative-qmlplugins \
    qtdeclarative-tools \
    qtsvg \
    qtsvg-plugins \
    qtsvg-qmlplugins \
    liberation-fonts \
    hello-qt \
"

#
# INSTALL addons
#
CORE_IMAGE_EXTRA_INSTALL += " \
    ${IMAGE_QT_MIN} \
"

IMAGE_FEATURES += "dev-pkgs"
