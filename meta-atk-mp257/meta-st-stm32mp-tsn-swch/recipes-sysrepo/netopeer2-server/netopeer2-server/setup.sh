#!/bin/bash

if [ $# -lt 2 ]; then
    echo "Usage $0 <sysrepoctl-path> <sysrepocfg-path> <netopeer2-modules-directory> [<module-owner>]"
    exit
fi

SYSREPOCTL=$1
SYSREPOCFG=$2
MODDIR=$3
OWNER=${4:-`id -un`}
GROUP=`id -gn $OWNER`

# ietf-netconf-acm
$SYSREPOCTL -i $MODDIR/ietf-netconf-acm@2018-02-14.yang -v3 -a
$SYSREPOCTL -c ietf-netconf-acm -o $OWNER -g $GROUP -v3 -a
# ietf-netconf
$SYSREPOCTL -U $MODDIR/ietf-netconf@2013-09-29.yang -s $MODDIR -v3 -a
$SYSREPOCTL -c ietf-netconf -e writable-running -e candidate -e rollback-on-error -e validate -e startup -e url -e xpath -o $OWNER -g $GROUP -v3 -a
# ietf-netconf-monitoring
$SYSREPOCTL -i $MODDIR/ietf-netconf-monitoring@2010-10-04.yang -v3 -a
$SYSREPOCTL -c ietf-netconf-monitoring -o $OWNER -g $GROUP -v3 -a
# ietf-datastores
$SYSREPOCTL -i $MODDIR/ietf-datastores@2017-08-17.yang -v3 -a
$SYSREPOCTL -c ietf-datastores -o $OWNER -g $GROUP -v3 -a
# ietf-netconf-nmda
$SYSREPOCTL -i $MODDIR/ietf-netconf-nmda@2019-01-07.yang -e origin -e with-defaults -s $MODDIR -v3 -a
$SYSREPOCTL -c ietf-netconf-nmda -o $OWNER -g $GROUP -v2 -a
# notification modules
$SYSREPOCTL -i $MODDIR/nc-notifications@2008-07-14.yang -s $MODDIR -v3 -a
$SYSREPOCTL -c nc-notifications -o $OWNER -g $GROUP -v3 -a
$SYSREPOCTL -i $MODDIR/notifications@2008-07-14.yang -v3 -a
$SYSREPOCTL -c notifications -o $OWNER -g $GROUP -v3 -a
# ietf-netconf-server modules
$SYSREPOCTL -i $MODDIR/ietf-x509-cert-to-name@2014-12-10.yang -v3 -a
$SYSREPOCTL -c ietf-x509-cert-to-name -o $OWNER -g $GROUP -v3 -a
$SYSREPOCTL -i $MODDIR/ietf-crypto-types@2019-07-02.yang -v3 -a
$SYSREPOCTL -c ietf-crypto-types -o $OWNER -g $GROUP -v3 -a
$SYSREPOCTL -i $MODDIR/ietf-keystore@2019-07-02.yang -e keystore-supported -s $MODDIR -v3 -a
$SYSREPOCTL -c ietf-keystore -o $OWNER -g $GROUP -v3 -a
$SYSREPOCTL -i $MODDIR/ietf-truststore@2019-07-02.yang -e truststore-supported -e x509-certificates -s $MODDIR -v3 -a
$SYSREPOCTL -c ietf-truststore -o $OWNER -g $GROUP -v3 -a
$SYSREPOCTL -i $MODDIR/ietf-tcp-common@2019-07-02.yang -e keepalives-supported -s $MODDIR -v3 -a
$SYSREPOCTL -c ietf-tcp-common -o $OWNER -g $GROUP -v3 -a
$SYSREPOCTL -i $MODDIR/ietf-ssh-server@2019-07-02.yang -e local-client-auth-supported -s $MODDIR -v3 -a
$SYSREPOCTL -c ietf-ssh-server -o $OWNER -g $GROUP -v3 -a
$SYSREPOCTL -i $MODDIR/ietf-tls-server@2019-07-02.yang -e local-client-auth-supported -s $MODDIR -v3 -a
$SYSREPOCTL -c ietf-tls-server -o $OWNER -g $GROUP -v3 -a
$SYSREPOCTL -i $MODDIR/ietf-netconf-server@2019-07-02.yang -e ssh-listen -e tls-listen -e ssh-call-home -e tls-call-home -s $MODDIR -v3 -a
$SYSREPOCTL -c ietf-netconf-server -o $OWNER -g $GROUP -v3 -a

echo "ieee802-dot1q-fqtss"
# ieee802-dot1q-fqtss module
$SYSREPOCTL -i $MODDIR/ieee802-dot1q-fqtss.yang -s $MODDIR -v3 -a
$SYSREPOCTL -c ieee802-dot1q-fqtss -p 666 -o $OWNER -g $GROUP -v3 -a

echo "ietf-interfaces"
# ietf-interfaces module
$SYSREPOCTL -i $MODDIR/ietf-interfaces.yang -s $MODDIR -v3 -a
$SYSREPOCTL -c ietf-interfaces -p 666 -o $OWNER -g $GROUP -v3 -a

echo "ieee802-dot1q-bridge"
# ieee802-dot1q-bridge module
$SYSREPOCTL -i $MODDIR/ieee802-dot1q-bridge.yang -s $MODDIR -v3 -a
$SYSREPOCTL -c ieee802-dot1q-bridge -p 666 -o $OWNER -g $GROUP -v3 -a

echo "ieee802-dot1ab-lldp"
# ieee802-dot1ab-lldp module
$SYSREPOCTL -i $MODDIR/ieee802-dot1ab-lldp.yang -s $MODDIR -v3 -a
$SYSREPOCTL -c ieee802-dot1ab-lldp -p 666 -o $OWNER -g $GROUP -v3 -a

echo "ietf-routing"
# imported modules which needs to be installed
$SYSREPOCTL -i $MODDIR/ietf-routing.yang -v2 -s $MODDIR -v3 -a
$SYSREPOCTL -c ietf-routing -p 666 -o $OWNER -g $GROUP -v3 -a
echo "iana-if-type"
$SYSREPOCTL -i $MODDIR/iana-if-type.yang -v2 -s $MODDIR -v3 -a
$SYSREPOCTL -c iana-if-type -p 666 -o $OWNER -g $GROUP -v3 -a

echo "ieee802-dot1q-preemption"
# ieee802-dot1q-preemption module
$SYSREPOCTL -i $MODDIR/ieee802-dot1q-sched.yang -s $MODDIR -v3 -a
$SYSREPOCTL -c ieee802-dot1q-sched -p 666 -o $OWNER -g $GROUP -v3 -a

echo "ieee802-dot1q-sched"
# ieee802-dot1q-sched module
$SYSREPOCTL -i $MODDIR/ieee802-dot1q-preemption.yang -s $MODDIR -v3 -a
$SYSREPOCTL -c ieee802-dot1q-preemption -p 666 -o $OWNER -g $GROUP -v3 -a

echo "ieee802-dot3br-preempt"
# ieee802-dot3br-preempt module
$SYSREPOCTL -i $MODDIR/ieee802-dot3br-preempt.yang -s $MODDIR -v3 -a
$SYSREPOCTL -c ieee802-dot3br-preempt -p 666 -o $OWNER -g $GROUP -v3 -a

echo "ieee802-ethernet-interface"
# ieee802-ethernet-interface module
$SYSREPOCTL -i $MODDIR/ieee802-ethernet-interface.yang -s $MODDIR -v3 -a
$SYSREPOCTL -c ieee802-ethernet-interface -p 666 -o $OWNER -g $GROUP -v3 -a

echo "sysrepo-module-versions"
# sysrepo-module-versions module
$SYSREPOCTL -i $MODDIR/sysrepo-module-versions.yang -s $MODDIR -v3 -a
$SYSREPOCTL -c sysrepo-module-versions -p 666 -o $OWNER -g $GROUP -v3 -a

echo "ieee8021-mstp"
# ieee8021-mstp module
$SYSREPOCTL -i $MODDIR/ieee8021-mstp.yang -s $MODDIR -v3 -a
$SYSREPOCTL -c ieee8021-mstp -p 666 -o $OWNER -g $GROUP -v3 -a

echo "ietf-ptp"
# ietf-ptp module
$SYSREPOCTL -i $MODDIR/ietf-ptp.yang -s $MODDIR -v3 -a
$SYSREPOCTL -c ietf-ptp -p 666 -o $OWNER -g $GROUP -v3 -a

echo "ieee802-dot1cb-stream-identification-types"
# ieee802-dot1cb-stream-identification-types module
$SYSREPOCTL -i $MODDIR/ieee802-dot1cb-stream-identification-types.yang -s $MODDIR -v3 -a
$SYSREPOCTL -c ieee802-dot1cb-stream-identification-types -p 666 -o $OWNER -g $GROUP -v3 -a

echo "ieee802-dot1cb-stream-identification"
# ieee802-dot1cb-stream-identification module
$SYSREPOCTL -i $MODDIR/ieee802-dot1cb-stream-identification.yang -s $MODDIR -v3 -a
$SYSREPOCTL -c ieee802-dot1cb-stream-identification -p 666 -o $OWNER -g $GROUP -v3 -a

echo "ieee802-dot1cb-stream-identification-params"
# ieee802-dot1cb-stream-identification-params module
$SYSREPOCTL -i $MODDIR/ieee802-dot1cb-stream-identification-params.yang -s $MODDIR -v3 -a
$SYSREPOCTL -c ieee802-dot1cb-stream-identification-params -p 666 -o $OWNER -g $GROUP -v3 -a

echo "ieee802-dot1cb-frer-types"
# ieee802-dot1cb-frer-types module
$SYSREPOCTL -i $MODDIR/ieee802-dot1cb-frer-types.yang -s $MODDIR -v3 -a
$SYSREPOCTL -c ieee802-dot1cb-frer-types -p 666 -o $OWNER -g $GROUP -v3 -a

echo "ieee802-dot1cb-frer-types"
# ieee802-dot1cb-frer module
$SYSREPOCTL -i $MODDIR/ieee802-dot1cb-frer.yang -s $MODDIR -v3 -a
$SYSREPOCTL -c ieee802-dot1cb-frer -p 666 -o $OWNER -g $GROUP -v3 -a

echo "ieee802-dot1q-stream-filters-gates"
# ieee802-dot1q-stream-filters-gates module
$SYSREPOCTL -i $MODDIR/ieee802-dot1q-stream-filters-gates.yang -s $MODDIR -v3 -a
$SYSREPOCTL -c ieee802-dot1q-stream-filters-gates -p 666 -o $OWNER -g $GROUP -v3 -a

echo "ieee802-dot1q-psfp"
# ieee802-dot1q-psfp module
$SYSREPOCTL -i $MODDIR/ieee802-dot1q-psfp.yang -s $MODDIR -v3 -a
$SYSREPOCTL -c ieee802-dot1q-psfp -p 666 -o $OWNER -g $GROUP -v3 -a

echo "ieee802-dot1q-bridge-delays"
# ieee802-dot1q-bridge-delays module
$SYSREPOCTL -i $MODDIR/ieee802-dot1q-bridge-delays.yang -s $MODDIR -v3 -a
$SYSREPOCTL -c ieee802-dot1q-bridge-delays -p 666 -o $OWNER -g $GROUP -v3 -a

echo "enable features"
# enable module features
$SYSREPOCTL -c ietf-interfaces -e if-mib -o $OWNER -g $GROUP -v3 -a
$SYSREPOCTL -c ieee802-dot1q-preemption -e frame-preemption -o $OWNER -g $GROUP -v3 -a
$SYSREPOCTL -c ieee802-dot3br-preempt -e mac-merge -o $OWNER -g $GROUP -v3 -a
$SYSREPOCTL -c ieee802-dot1q-sched -e scheduled-traffic -o $OWNER -g $GROUP -v3 -a
$SYSREPOCTL -c ieee802-ethernet-interface -e ethernet-pfc -o $OWNER -g $GROUP -v3 -a
$SYSREPOCTL -c ieee802-ethernet-interface -e ethernet-pause -o $OWNER -g $GROUP -v3 -a
$SYSREPOCTL -c ieee802-dot1q-bridge -e extended-filtering-services -o $OWNER -g $GROUP -v3 -a

echo "setup sysrepo plugins boot order"
$SYSREPOCFG --import=/usr/share/netopeer2-server/sysrepo_plugins_boot_order.xml --datastore=startup
rm -rf /dev/shm/*

