#!/bin/bash

# apply it to startup and running
sysrepocfg --edit=/usr/share/netopeer2-server/startup_tls_truststore.xml -d startup -f xml -m ietf-truststore -v2
sysrepocfg -C startup -m ietf-truststore -v2
sysrepocfg -C running -m ietf-truststore -v2

sysrepocfg --edit=/usr/share/netopeer2-server/startup_tls_keystore.xml -d startup -f xml -m ietf-keystore -v2
sysrepocfg -C startup -m ietf-keystore -v2
sysrepocfg -C running -m ietf-keystore -v2

sysrepocfg --edit=/usr/share/netopeer2-server/startup_tls_server_conf.xml -d startup -f xml -m ietf-netconf-server -v2
sysrepocfg -C startup -m ietf-netconf-server -v2
sysrepocfg -C running -m ietf-netconf-server -v2


