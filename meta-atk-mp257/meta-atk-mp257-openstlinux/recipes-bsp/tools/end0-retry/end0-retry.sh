#!/bin/sh -

# At boot, systemd-networkd may bring up end0 before the Ethernet MAC
# (eth2) DMA is ready, causing "Failed to reset the dma" and leaving the
# interface DOWN. This service retries until the interface is successfully
# brought up (idempotent if already up).

DEV=${END0_RETRY_DEV:-end0}
RETRIES=${END0_RETRY_RETRIES:-20}
DELAY=${END0_RETRY_DELAY:-2}
i=0

while [ $i -lt "$RETRIES" ]; do
    i=$((i + 1))
    if [ -e "/sys/class/net/$DEV" ]; then
        if ip link show "$DEV" | grep -q "state UP" ||
           ip link show "$DEV" | grep -q "state UNKNOWN"; then
            exit 0
        fi
        # Try to bring the interface up.
        if ip link set "$DEV" up 2>/dev/null; then
            sleep 1
            if ip link show "$DEV" | grep -q "state UP" ||
               ip link show "$DEV" | grep -q "state UNKNOWN"; then
                exit 0
            fi
        fi
    fi
    sleep "$DELAY"
done

exit 0
