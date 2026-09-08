SUMMARY = "Minimal Qt6 'hello' GUI demo for the ALIENTEK STM32MP257 board"
HOMEPAGE = "https://github.com/ALIENTEK"
SECTION = "examples"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

DEPENDS = "qtbase"

inherit qt6-cmake

# Sanity: this is a Wayland Qt client
REQUIRED_DISTRO_FEATURES = "wayland"
inherit features_check

# locate the bundled sources (same dir as the recipe)
FILESEXTRAPATHS:prepend := "${THISDIR}:"

SRC_URI = " \
    file://CMakeLists.txt \
    file://main.cpp \
"

S = "${WORKDIR}"
