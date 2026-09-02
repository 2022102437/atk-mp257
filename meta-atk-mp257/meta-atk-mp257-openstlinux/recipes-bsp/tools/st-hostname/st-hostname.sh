#!/bin/sh -

# ATK: keep the hostname fixed (stm32mp257-atk), do not append the MAC address.
hostnamectl hostname stm32mp257-atk
hostnamectl --transient hostname stm32mp257-atk
sed -i "s/.*/stm32mp257-atk/" /etc/hostname 2>/dev/null || echo stm32mp257-atk > /etc/hostname
if grep -q SendHostname /usr/lib/systemd/network/80-wired.network 2>/dev/null; then
    sed -i "s|Hostname=.*$|Hostname=stm32mp257-atk|" /usr/lib/systemd/network/80-wired.network
else
    echo "SendHostname=true" >> /usr/lib/systemd/network/80-wired.network
    echo "Hostname=stm32mp257-atk" >> /usr/lib/systemd/network/80-wired.network
fi


