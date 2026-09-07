# Overwrite of do_unpack to untar the tarball

python() {
    # Make sure that we're dealing with recipe that enables externalsrc class
    if bb.data.inherits_class('externalsrc', d):
        bb.build.addtask('do_tttech_binaries_unpack', 'do_populate_lic', None, d)
        bb.build.addtask('do_tttech_binaries_unpack', 'do_configure', None, d)
}

do_tttech_binaries_unpack[depends] += "xz-native:do_populate_sysroot"
do_tttech_binaries_unpack() {
    cd ${TTTECH_BINARIES_PATH}

    if [ -f "${TTTECH_BINARY_TARBALL}.bin" ]; then
        sh ${TTTECH_BINARY_TARBALL}.bin --auto-accept
    else
        bbfatal "Missing '${TTTECH_BINARY_TARBALL}.bin' file in ${S} folder."
    fi
    if [ -d ${TTTECH_BINARY_ARCH} ]; then
        #copy the license
        cp ${TSN_BASE_LAYER}/recipes-TTTECH-license/TTTECH-license/files/TTTECH_license.txt ${TTTECH_BINARY_ARCH}
    fi
}


do_unpack[depends] += "xz-native:do_populate_sysroot"
python do_unpack() {
    eula = d.getVar('ACCEPT_EULA_'+d.getVar('MACHINE'))
    eula_file = d.getVar('EULA_FILE_ST')
    machine = d.getVar('MACHINE')
    pkg = d.getVar('PN')
    if eula == None:
        bb.fatal("To use '%s' you need to accept the STMicroelectronics EULA at '%s'. "
                 "Please read it and in case you accept it, write: "
                 "ACCEPT_EULA_%s = \"1\" in your local.conf." % (pkg, eula_file, machine))
    elif eula == '0':
        bb.fatal("To use '%s' you need to accept the STMicroelectronics EULA." % pkg)
    else:
        bb.note("STMicroelectronics EULA has been accepted for '%s'" % pkg)

    try:
        externalsrc = d.getVar('EXTERNALSRC')
        if not externalsrc:
            bb.build.exec_func('base_do_unpack', d)
            bb.build.exec_func('do_tttech_binaries_unpack', d)
    except:
        raise
}
do_unpack[vardepsexclude] += "EULA_FILE_ST"

# Needed for binary package to pass Yocto QA
INSANE_SKIP:${PN} = "already-stripped file-rdeps"
ALL_QA:remove = "libdir"
