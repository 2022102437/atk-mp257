BBCLASSEXTEND = "native"

RDEPENDS:${PN}:class-native = ""
RDEPENDS:${PN}_sshd:class-native = ""
RDEPENDS:${PN}_ptest:class-native = ""

RPROVIDES:openssh-native += " openssh-native-scp-native openssh-native-ssh-native openssh-native-keygen-native openssh-native-sshd-native"

do_install:append () {
	mkdir -p ${D}${localstatedir}/run/sshd ${D}${localstatedir}/run ${D}${localstatedir}
}

do_install:prepend () {
	sed -i -e 's/\ check-config\>//g' ${S}/Makefile
	mkdir -p ${D}${localstatedir}/run/sshd ${D}${localstatedir}/run ${D}${localstatedir}
}

do_install:append:class-target () {
        if [ "${@bb.utils.filter('DISTRO_FEATURES', 'pam', d)}" ]; then
                install -D -m 0644 ${WORKDIR}/sshd ${D}${sysconfdir}/pam.d/sshd
                sed -i -e 's:#UsePAM no:UsePAM yes:' ${D}${sysconfdir}/ssh/sshd_config
        fi

        if [ "${@bb.utils.filter('DISTRO_FEATURES', 'x11', d)}" ]; then
                sed -i -e 's:#X11Forwarding no:X11Forwarding yes:' ${D}${sysconfdir}/ssh/sshd_config
        fi

        install -d ${D}${sysconfdir}/init.d
        install -m 0755 ${WORKDIR}/init ${D}${sysconfdir}/init.d/sshd
        rm -f ${D}${bindir}/slogin ${D}${datadir}/Ssh.bin
        rmdir ${D}${localstatedir}/run/sshd ${D}${localstatedir}/run ${D}${localstatedir}
        install -d ${D}/${sysconfdir}/default/volatiles
        install -m 644 ${WORKDIR}/volatiles.99_sshd ${D}/${sysconfdir}/default/volatiles/99_sshd
        install -m 0755 ${S}/contrib/ssh-copy-id ${D}${bindir}

        # Create config files for read-only rootfs
        install -d ${D}${sysconfdir}/ssh
        install -m 644 ${D}${sysconfdir}/ssh/sshd_config ${D}${sysconfdir}/ssh/sshd_config_readonly
        sed -i '/HostKey/d' ${D}${sysconfdir}/ssh/sshd_config_readonly
        echo "HostKey /var/run/ssh/ssh_host_rsa_key" >> ${D}${sysconfdir}/ssh/sshd_config_readonly
        echo "HostKey /var/run/ssh/ssh_host_dsa_key" >> ${D}${sysconfdir}/ssh/sshd_config_readonly
        echo "HostKey /var/run/ssh/ssh_host_ecdsa_key" >> ${D}${sysconfdir}/ssh/sshd_config_readonly
        echo "HostKey /var/run/ssh/ssh_host_ed25519_key" >> ${D}${sysconfdir}/ssh/sshd_config_readonly

        install -d ${D}${systemd_unitdir}/system
        install -c -m 0644 ${WORKDIR}/sshd.socket ${D}${systemd_unitdir}/system
        install -c -m 0644 ${WORKDIR}/sshd@.service ${D}${systemd_unitdir}/system
        install -c -m 0644 ${WORKDIR}/sshdgenkeys.service ${D}${systemd_unitdir}/system
        sed -i -e 's,@BASE_BINDIR@,${base_bindir},g' \
                -e 's,@SBINDIR@,${sbindir},g' \
                -e 's,@BINDIR@,${bindir},g' \
                -e 's,@LIBEXECDIR@,${libexecdir}/${BPN},g' \
                ${D}${systemd_unitdir}/system/sshd.socket ${D}${systemd_unitdir}/system/*.service

        sed -i -e 's,@LIBEXECDIR@,${libexecdir}/${BPN},g' \
                ${D}${sysconfdir}/init.d/sshd

        install -D -m 0755 ${WORKDIR}/sshd_check_keys ${D}${libexecdir}/${BPN}/sshd_check_keys
}

do_install:append:class-native () {
        if [ "${@bb.utils.filter('DISTRO_FEATURES', 'pam', d)}" ]; then
                install -D -m 0644 ${WORKDIR}/sshd ${D}${sysconfdir}/pam.d/sshd
                sed -i -e 's:#UsePAM no:UsePAM yes:' ${D}${sysconfdir}/ssh/sshd_config
        fi

        if [ "${@bb.utils.filter('DISTRO_FEATURES', 'x11', d)}" ]; then
                sed -i -e 's:#X11Forwarding no:X11Forwarding yes:' ${D}${sysconfdir}/ssh/sshd_config
        fi

        install -d ${D}${sysconfdir}/init.d
        install -m 0755 ${WORKDIR}/init ${D}${sysconfdir}/init.d/sshd
        rm -f ${D}${bindir}/slogin ${D}${datadir}/Ssh.bin
        install -d ${D}/${sysconfdir}/default/volatiles
        install -m 644 ${WORKDIR}/volatiles.99_sshd ${D}/${sysconfdir}/default/volatiles/99_sshd
        install -m 0755 ${S}/contrib/ssh-copy-id ${D}${bindir}

        # Create config files for read-only rootfs
        install -d ${D}${sysconfdir}/ssh
        install -m 644 ${D}${sysconfdir}/ssh/sshd_config ${D}${sysconfdir}/ssh/sshd_config_readonly
        sed -i '/HostKey/d' ${D}${sysconfdir}/ssh/sshd_config_readonly
        echo "HostKey /var/run/ssh/ssh_host_rsa_key" >> ${D}${sysconfdir}/ssh/sshd_config_readonly
        echo "HostKey /var/run/ssh/ssh_host_dsa_key" >> ${D}${sysconfdir}/ssh/sshd_config_readonly
        echo "HostKey /var/run/ssh/ssh_host_ecdsa_key" >> ${D}${sysconfdir}/ssh/sshd_config_readonly
        echo "HostKey /var/run/ssh/ssh_host_ed25519_key" >> ${D}${sysconfdir}/ssh/sshd_config_readonly

        install -d ${D}${systemd_unitdir}/system
        install -c -m 0644 ${WORKDIR}/sshd.socket ${D}${systemd_unitdir}/system
        install -c -m 0644 ${WORKDIR}/sshd@.service ${D}${systemd_unitdir}/system
        install -c -m 0644 ${WORKDIR}/sshdgenkeys.service ${D}${systemd_unitdir}/system
        sed -i -e 's,@BASE_BINDIR@,${base_bindir},g' \
                -e 's,@SBINDIR@,${sbindir},g' \
                -e 's,@BINDIR@,${bindir},g' \
                -e 's,@LIBEXECDIR@,${libexecdir}/${BPN},g' \
                ${D}${systemd_unitdir}/system/sshd.socket ${D}${systemd_unitdir}/system/*.service

        sed -i -e 's,@LIBEXECDIR@,${libexecdir}/${BPN},g' \
                ${D}${sysconfdir}/init.d/sshd

        install -D -m 0755 ${WORKDIR}/sshd_check_keys ${D}${libexecdir}/${BPN}/sshd_check_keys
}
