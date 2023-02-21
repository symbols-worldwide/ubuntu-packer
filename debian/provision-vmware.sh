#!/bin/bash

set -e

apt-get install -y libaio1 libpcsclite1

wget -O /root/vmware.bundle http://cutiefly.cubbington.eu.widgit.com/vmware-workstation-linux-latest
chmod u+x /root/vmware.bundle
/root/vmware.bundle

if [ ! -f /etc/vmware/netmap.conf ] ; then
cat << EOF > /etc/vmware/netmap.conf
# This file is automatically generated.
# Hand-editing this file is not recommended.
network0.name = "Bridged"
network0.device = "vmnet0"
network1.name = "HostOnly"
network1.device = "vmnet1"
network8.name = "NAT"
network8.device = "vmnet8"
EOF
fi
