#!/bin/bash
set -e

# avoid problems with sudo path
SYSREPOCFG=`su -c "which sysrepocfg" $USER`
OPENSSL=`su -c "which openssl" $USER`

# check that there is no SSH key with this name yet
KEYSTORE_KEY=`$SYSREPOCFG -X -x "/ietf-keystore:keystore/asymmetric-keys/asymmetric-key[name='genkey']/name"`
if [ -z "$KEYSTORE_KEY" ]; then
	test -d /etc/ssh || mkdir -p /etc/ssh/
	#test if ssh_host_rsa_key are present
	if [ -e /etc/ssh/ssh_host_rsa_key ]; then
	    rm -f /etc/ssh/ssh_host_rsa_key
	fi
	# force creation of ssh key
	$OPENSSL genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -outform PEM > /etc/ssh/ssh_host_rsa_key 2>/dev/null

	# sysvinit
	if [ -f /etc/init.d/dropbear ]; then
		rm -f /etc/dropbear/dropbear_rsa_host_key
		# create a temporary rsa key
		cp /etc/ssh/ssh_host_rsa_key /tmp/ssh_host_rsa_key
		chmod 700 /tmp/ssh_host_rsa_key
		# transform rsa key on openssh key
		ssh-keygen -p  -N "" -f /tmp/ssh_host_rsa_key
		/usr/sbin/dropbearconvert openssh dropbear /tmp/ssh_host_rsa_key /etc/dropbear/dropbear_rsa_host_key 2>/dev/null
	fi
	echo "################# 2"
	# systemd
	if [ -f /lib/systemd/system/dropbear.socket ]; then
		rm -f /etc/dropbear/dropbear_rsa_host_key
		# create a temporary rsa key
		cp /etc/ssh/ssh_host_rsa_key /tmp/ssh_host_rsa_key
		chmod 700 /tmp/ssh_host_rsa_key
		# transform rsa key on openssh key
		ssh-keygen -p  -N "" -f /tmp/ssh_host_rsa_key 2>/dev/null
		/usr/sbin/dropbearconvert openssh dropbear /tmp/ssh_host_rsa_key /etc/dropbear/dropbear_rsa_host_key 2>/dev/null
	fi
	PRIVPEM=$(cat /etc/ssh/ssh_host_rsa_key)

	# remove header/footer
	PRIVKEY=$(cat /etc/ssh/ssh_host_rsa_key | grep -v "\-----" )

	# get public key
	PUBPEM=$(cat /etc/ssh/ssh_host_rsa_key | $OPENSSL rsa -pubout 2>/dev/null | tee /tmp/rsa.pem)

	# remove header/footer
	PUBKEY=$(cat /tmp/rsa.pem | grep -v "\-----" )


	# generate edit config
	CONFIG="<keystore xmlns=\"urn:ietf:params:xml:ns:yang:ietf-keystore\">
    <asymmetric-keys>
        <asymmetric-key>
            <name>genkey</name>
            <algorithm>rsa2048</algorithm>
            <public-key>$PUBKEY</public-key>
            <private-key>$PRIVKEY</private-key>
        </asymmetric-key>
    </asymmetric-keys>
</keystore>"
	TMPFILE=`mktemp -u`
	printf -- "$CONFIG" > $TMPFILE

	cat /etc/ssh/ssh_host_rsa_key | $OPENSSL rsa -pubout 2>/dev/null 1>/etc/ssh/ssh_host_rsa_key.pub

	# apply it to startup and running
	$SYSREPOCFG --edit=$TMPFILE -d startup -f xml -m ietf-keystore -v2
	$SYSREPOCFG -C startup -m ietf-keystore -v2
	# remove the tmp file
	rm $TMPFILE  /tmp/rsa.pem /tmp/ssh_host_rsa_key
fi
