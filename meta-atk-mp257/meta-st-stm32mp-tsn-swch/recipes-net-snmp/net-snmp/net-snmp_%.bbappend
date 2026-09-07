FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "file://snmp.conf \
            file://snmpd_1.0.1.conf \
            file://init \
"
PACKAGECONFIG = "${@bb.utils.filter('DISTRO_FEATURES', 'ipv6', d)} des libnl"

EXTRA_OECONF = "--disable-embedded-perl \
                --with-perl-modules=no \
                --disable-manuals \
                --with-defaults \
                --with-install-prefix=${D} \
                --with-persistent-directory=${localstatedir}/lib/net-snmp \
                ${@oe.utils.conditional('SITEINFO_ENDIANNESS', 'le', '--with-endianness=little', '--with-endianness=big', d)} \
                --with-openssl=${STAGING_EXECPREFIXDIR} \
"

do_install:append() {
    install -d ${D}${sysconfdir}/snmp
    install -d ${D}${sysconfdir}/init.d
    install -m 0755 ${WORKDIR}/init ${D}${sysconfdir}/init.d/snmpd
    install -m 0644 ${WORKDIR}/snmpd_1.0.1.conf ${D}${sysconfdir}/snmp/snmpd.conf
    install -m 0644 ${WORKDIR}/snmp.conf ${D}${sysconfdir}/snmp/
    install -m 0644 ${WORKDIR}/snmptrapd.conf ${D}${sysconfdir}/snmp/
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/snmpd.service ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/snmptrapd.service ${D}${systemd_unitdir}/system
    cp ${S}/net-snmp-config ${D}${bindir}/net-snmp-config
    sed -e "s@^NSC_SRCDIR=.*@NSC_SRCDIR=.@g" \
        -i ${D}${bindir}/net-snmp-create-v3-user
    sed -e 's@^NSC_SRCDIR=.*@NSC_SRCDIR=.@g' \
        -e 's@[^ ]*-fdebug-prefix-map=[^ "]*@@g' \
        -e 's@[^ ]*--sysroot=[^ "]*@@g' \
        -e 's@[^ ]*--with-libtool-sysroot=[^ "]*@@g' \
        -e 's@[^ ]*--with-install-prefix=[^ "]*@@g' \
        -e 's@[^ ]*PKG_CONFIG_PATH=[^ "]*@@g' \
        -e 's@[^ ]*PKG_CONFIG_LIBDIR=[^ "]*@@g' \
        -i ${D}${bindir}/net-snmp-config

    if [ "${HAS_PERL}" = "1" ]; then
        sed -e "s@^NSC_INCLUDEDIR=.*@NSC_INCLUDEDIR=\$\{includedir\}@g" \
            -e "s@^NSC_LIBDIR=-L.*@NSC_LIBDIR=-L\$\{libdir\}@g" \
            -i ${D}${bindir}/net-snmp-config
    fi
    # Commented as is not needed for our targets and creates issues, if x86, arm64... is targeted then we will have to investigate it
    # oe_multilib_header net-snmp/net-snmp-config.h
}

FILES:${PN}-server-snmpd = "${sbindir}/snmpd \
                            ${sysconfdir}/snmp/snmp.conf \
                            ${sysconfdir}/snmp/snmpd.conf \
                            ${sysconfdir}/init.d \
                            ${systemd_unitdir}/system/snmpd.service \
"

CONFFILES:${PN}-server-snmpd = "${sysconfdir}/snmp/snmpd.conf ${sysconfdir}/snmp/snmp.conf"

addtask fix_extension before do_package do_populate_sysroot after do_install

do_populate_sysroot[depends] += "${PN}:do_fix_extension"

fakeroot do_fix_extension() {
cd ${MIBS_DIR}
find -type f -name '*.txt' | while read f; do mv "$f" "${f%.txt}"; done
}

MIBS_DIR="${D}/${datadir}/snmp/mibs/"

# disable start of service by default
SYSTEMD_AUTO_ENABLE:${PN} = "disable"
INITSCRIPT_PARAMS = "stop 20 0 1 6 ."

