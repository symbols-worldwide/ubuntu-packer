#!/bin/bash

set -e

apt-get install -y parted

cat > /usr/local/bin/resize-root.sh <<EOF
#!/bin/bash

echo "d
3
n
p
3



w" | fdisk /dev/sda

partprobe /dev/sda
pvresize /dev/sda3
lvextend -r -l +100%FREE /dev/mapper/debian--vg-root
EOF

chmod +x /usr/local/bin/resize-root.sh

cat > /etc/systemd/system/resize-root.service <<EOF
[Unit]
Description=Resize root filesystem to full disk size

[Service]
Type=oneshot
ExecStart=/usr/local/bin/resize-root.sh
RemainAfterExit=true

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable resize-root.service

rm /etc/apparmor.d/sbin.dhclient
INTF=$(ip a | grep ens | awk -F': ' '{print $2}')
echo 'iface ens160 inet dhcp' > /etc/network/interfaces.d/default
echo "iface $INTF inet dhcp" > /etc/network/interfaces.d/guessed
