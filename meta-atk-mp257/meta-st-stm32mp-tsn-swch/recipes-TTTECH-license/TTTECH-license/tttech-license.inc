FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

LICENSE = "TTTECH-license"

SRC_URI:append = " file://TTTECH_license.txt "
do_patch[postfuncs] += "copy_tttech_license_on_source"
copy_tttech_license_on_source() {
    # for create_spdx
    cp -f ${WORKDIR}/TTTECH_license.txt ${S}
}

NO_GENERIC_LICENSE[TTTECH-license] = "TTTECH_license.txt"

LICENSE:${PN} = "TTTECH-license"

#LIC_FILES_CHKSUM += "file://${TSN_BASE_LAYER}/recipes-TTTECH-license/TTTECH-license/files/TTTECH_license.txt;md5=d12dd2f914563a1de26d6396e476ad4d"
LIC_FILES_CHKSUM += "file://TTTECH_license.txt;md5=3c3cb74099b58d8872679cc6b03c0391"
