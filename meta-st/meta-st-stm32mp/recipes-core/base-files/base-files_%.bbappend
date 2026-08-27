FILESEXTRAPATHS:prepend:stm32mpcommon := "${THISDIR}/${PN}:"

do_install:append () {
    if [ "${ST_USERFS}" = "1" ]; then
        install -d ${D}${prefix}/local
    fi
    if [ "${ST_VENDORFS}" = "1" ]; then
        install -d ${D}/vendor
    fi
}
