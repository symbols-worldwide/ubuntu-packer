#!/bin/bash

set -e
set -x

if [ "$PACKER_BUILDER_TYPE" != "vmware-iso" ]; then
  exit 0
fi

echo Fetching VMware workstation
wget -O /home/vagrant/vmware.bin.sh http://cutiefly.cubbington.eu.widgit.com/VMware-Workstation-Full-14.1.3-9474260.x86_64.bundle

# https://www.vmware.com/go/getworkstation-linux is now version 15 which doesn't seem to have command-line entering of serial number after installation

echo Installing VMware workstation
sh /home/vagrant/vmware.bin.sh --console --required --eulas-agreed

echo Installing X dependencies
apt-get install -y libx11-6 libxext6 libxi6 libxinerama1 libxcursor1 libxtst6

echo Performing post-installation appeasement of packer and vagrant plugin

# required to keep the vagrant plugin happy :rolleyes:
cat <<EOF > /etc/init.d/vmware
#!/bin/bash

/usr/bin/vmware-networks --start
EOF
chmod +x /etc/init.d/vmware

# Load VMWare modules at boot so that the vmware networking can start
echo 'vmnet' > /etc/modules-load.d/vmnet.conf
echo 'vmmon' > /etc/modules-load.d/vmmon.conf

# hacks to make packer work!
mkdir -p /etc/vmware/vmnet8/dhcpd
cd /etc/vmware/vmnet8
ln -s dhcpd dhcp
ln -s dhcpd.conf dhcp/dhcp.conf

mkdir -p /etc/vmware/vmnet1/dhcpd
cd /etc/vmware/vmnet1
ln -s dhcpd dhcp
ln -s dhcpd.conf dhcp/dhcp.conf

cat <<EOF > /etc/vmware/netmap.conf
# This file is automatically generated.
# Hand-editing this file is not recommended.
network0.name = "Bridged"
network0.device = "vmnet0"
network1.name = "HostOnly"
network1.device = "vmnet1"
network2.name = "NAT"
network2.device = "vmnet8"
EOF

# disabled due to issues when bootstrapping new boxes under vmware.
# enable when ready
# systemctl enable vmware.target

apt install -y open-vm-tools
mkdir -p /mnt/hgfs