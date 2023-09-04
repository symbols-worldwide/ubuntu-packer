#!/bin/bash

set -e

cat > /usr/local/bin/configure-nic.sh <<EOF
#!/bin/bash

CARD=$(find /sys/class/net -type l -not -lname '*virtual*' -printf '%f')
echo -e "allow-hotplug $CARD\niface $CARD inet dhcp" > /etc/network/interfaces.d/actual
EOF

chmod +x /usr/local/bin/configure-nic.sh

cat > /etc/systemd/system/configure-nic.service <<EOF
[Unit]
Description=Find out what the NIC is and configure it for DHCP
Before=network-pre.target
Wants=network-pre.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/configure-nic.sh
RemainAfterExit=true

[Install]
WantedBy=network.target
EOF

systemctl daemon-reload
systemctl enable configure-nic.service

# Remove apparmor so dhclient can operate
rm -f /etc/apparmor.d/sbin.dhclient

# Legacy stuff; probably unneeded but does very little harm to keep
INTF=$(ip a | grep ens | awk -F': ' '{print $2}')
echo "allow-hotplug ens160" > /etc/network/interfaces.d/default
echo "iface ens160 inet dhcp" >> /etc/network/interfaces.d/default
echo "allow-hotplug $INTF" > /etc/network/interfaces.d/guessed
echo "iface $INTF inet dhcp" >> /etc/network/interfaces.d/guessed
