SUMMARY = "Netopeer2 is a set of tools implementing network configuration tools based on the NETCONF Protocol."
DESCRIPTION = "Netopeer2 is based on the new generation of the NETCONF and YANG libraries - libyang and libnetconf2. The Netopeer server uses sysrepo as a NETCONF datastore implementation."
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENSE;md5=41daedff0b24958b2eba4f9086d782e1"

SRC_URI = "git://github.com/CESNET/Netopeer2.git;protocol=https;branch=libyang1 \
	   file://netopeer2-server \
	   file://setup.sh \
	   file://install_ssh_key.sh \
	   file://enable_ssh.sh \
	   file://install_and_enable_tls.sh \
	   file://startup_tls_truststore.xml \
	   file://startup_tls_keystore.xml \
	   file://startup_tls_server_conf.xml \
	   file://sysrepo_plugins_boot_order.xml \
	   file://0001-CMakeLists.patch.patch \
	   \
	   file://netopeer2-server.service \
	   file://netopeer2-server-service \
	   \
	   file://exec-netopeer2-cli.sh \
	   "
SRCREV = "1a4d404a91ab71f526bc42f8e482c4b675460dc8"
PR = "r0"

S = "${WORKDIR}/git"

DEPENDS += "libyang libnetconf2 sysrepo sysrepo-native curl libssh"
DEPENDS:class-native:append = " libyang libnetconf2 sysrepo curl libssh "
DEPENDS:class-nativesdk:append = " libyang libnetconf2 sysrepo curl libssh "

inherit cmake pkgconfig update-rc.d systemd

# Specify any options you want to pass to cmake using EXTRA_OECMAKE:
EXTRA_OECMAKE = " -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE:String=Release -DSYSREPOCTL_EXECUTABLE=${STAGING_INCDIR_NATIVE}/sysrepoctl \
		  -DSYSREPOCFG_EXECUTABLE=${STAGING_INCDIR_NATIVE}/sysrepocfg -DSTOCK_CONFIG=/usr/share/netopeer2-server/startup_server_conf.xml \
		  -DYANG_DIR=/etc/netopeer2/yang/ -DMODULES_OWNER=root -DGENERATE_HOSTKEY=OFF -DINSTALL_MODULES=OFF -DMERGE_LISTEN_CONFIG=OFF -DDEFAULT_HOSTKEY=ssh_host_rsa_key "

EXTRA_OECMAKE:class-native = " -DCMAKE_INSTALL_PREFIX=${STAGING_INCDIR_NATIVE}/usr -DCMAKE_BUILD_TYPE:String=Release -DSYSREPOCTL_EXECUTABLE=${STAGING_INCDIR_NATIVE}/sysrepoctl \
		  -DSYSREPOCFG_EXECUTABLE=${STAGING_INCDIR_NATIVE}/sysrepocfg -DSTOCK_CONFIG=${STAGING_INCDIR_NATIVE}/usr/share/netopeer2-server/startup_server_conf.xml \
		  -DYANG_DIR=${STAGING_INCDIR_NATIVE}/etc/netopeer2/yang/ -DMODULES_OWNER=root -DGENERATE_HOSTKEY=OFF -DINSTALL_MODULES=OFF -DMERGE_LISTEN_CONFIG=OFF -DDEFAULT_HOSTKEY=ssh_host_rsa_key "
EXTRA_OECMAKE:class-nativesdk = " -DCMAKE_INSTALL_PREFIX=${STAGING_INCDIR_NATIVE}/usr -DCMAKE_BUILD_TYPE:String=Release -DSYSREPOCTL_EXECUTABLE=${STAGING_INCDIR_NATIVE}/sysrepoctl \
		  -DSYSREPOCFG_EXECUTABLE=${STAGING_INCDIR_NATIVE}/sysrepocfg -DSTOCK_CONFIG=${STAGING_INCDIR_NATIVE}/usr/share/netopeer2-server/startup_server_conf.xml \
		  -DYANG_DIR=${STAGING_INCDIR_NATIVE}/etc/netopeer2/yang/ -DMODULES_OWNER=root -DGENERATE_HOSTKEY=OFF -DINSTALL_MODULES=OFF -DMERGE_LISTEN_CONFIG=OFF -DDEFAULT_HOSTKEY=ssh_host_rsa_key "


INITSCRIPT_NAME = "netopeer2-server"
INITSCRIPT_PARAMS = "disable"
SYSTEMD_SERVICE:${PN} = "netopeer2-server.service"
SYSTEMD_AUTO_ENABLE:${PN} = "disable"

do_install:append () {
    install -d ${D}${datadir}/netopeer2-server
    install -m 0755 ${WORKDIR}/install_ssh_key.sh ${D}${datadir}/netopeer2-server/
    install -m 0755 ${WORKDIR}/enable_ssh.sh ${D}${datadir}/netopeer2-server/
    install -m 0755 ${WORKDIR}/install_and_enable_tls.sh ${D}${datadir}/netopeer2-server/
    install -m 0755 ${WORKDIR}/setup.sh ${D}${datadir}/netopeer2-server/
    install -m 0555 ${WORKDIR}/startup_tls_*.xml ${D}${datadir}/netopeer2-server/
    install -m 0777 ${WORKDIR}/sysrepo_plugins_boot_order.xml ${D}${datadir}/netopeer2-server/
    install -d ${D}${sysconfdir}/netopeer2
    install -d ${D}${sysconfdir}/netopeer2/yang
    cp -r ${S}/modules/*.yang ${D}${sysconfdir}/netopeer2/yang/
    install -d ${D}${sysconfdir}/init.d
    install -m 0755 ${WORKDIR}/netopeer2-server ${D}${sysconfdir}/init.d/

    if ${@bb.utils.contains('DISTRO_FEATURES','systemd','true','false',d)}; then
        install -d ${D}${systemd_unitdir}/system
        install -m 0644 ${WORKDIR}/netopeer2-server.service ${D}${systemd_unitdir}/system/
    fi
    install -m 0755 ${WORKDIR}/netopeer2-server-service ${D}${datadir}/netopeer2-server/
}

RDEPENDS:${PN} += "bash"
FILES:${PN} += "${datadir}"

BBCLASSEXTEND += "native nativesdk"

# export client binaries to help for test
inherit deploy
do_deploy() {
    :
}
do_deploy:class-native() {
    install -d ${DEPLOYDIR}/scripts/lib ${DEPLOYDIR}/scripts/bin
    # netopeer2-cli
    install -m 0755 ${B}/netopeer2-cli ${DEPLOYDIR}/scripts/bin
    chrpath -r '../lib' ${DEPLOYDIR}/scripts/bin/netopeer2-cli
    # libyang.so.1
    install -m 0444 ${STAGING_LIBDIR_NATIVE}/libyang.so.1.* ${DEPLOYDIR}/scripts/lib
    ln -n ${STAGING_LIBDIR_NATIVE}/libyang.so.1.* ${DEPLOYDIR}/scripts/lib/libyang.so.1
    cp -ar ${STAGING_LIBDIR_NATIVE}/libyang ${DEPLOYDIR}/scripts/lib
    # libnetconf2.so.1
    install -m 0444 ${STAGING_LIBDIR_NATIVE}/libnetconf2.so.1.* ${DEPLOYDIR}/scripts/lib
    ln -n ${STAGING_LIBDIR_NATIVE}/libnetconf2.so.1.* ${DEPLOYDIR}/scripts/lib/libnetconf2.so.1
    # libcrypto.so.3
    install -m 0444 ${STAGING_LIBDIR_NATIVE}/libcrypto.so.3 ${DEPLOYDIR}/scripts/lib
    install -m 0444 ${STAGING_LIBDIR_NATIVE}/libssl.so.3 ${DEPLOYDIR}/scripts/lib
    install -m 0444 ${STAGING_LIBDIR_NATIVE}/libcrypt.so.2.* ${DEPLOYDIR}/scripts/lib
    ln -n ${STAGING_LIBDIR_NATIVE}/libcrypt.so.2.* ${DEPLOYDIR}/scripts/lib/libcrypt.so.2
    # libpcre
    install -m 0444 ${STAGING_LIBDIR_NATIVE}/libpcre.so.1.* ${DEPLOYDIR}/scripts/lib/
    ln -n ${STAGING_LIBDIR_NATIVE}/libpcre.so.1.* ${DEPLOYDIR}/scripts/lib/libpcre.so.1
    # script
    install -m 0755 ${WORKDIR}/exec-netopeer2-cli.sh ${DEPLOYDIR}/scripts/
}
addtask deploy before do_build after do_compile
