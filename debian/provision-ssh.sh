#!/bin/bash

set -e

PASS=$(dd if=/dev/random bs=1K count=1 2> /dev/null | md5sum | sed 's/ .*//')
echo -ne "${PASS}\n${PASS}\n" | passwd
cat << EOF > /etc/issue
Widgit VM (Debian Bookworm) - Docker and Virtualization enabled

EOF
cp /etc/issue /etc/issue.net

echo "********************************"
echo "Provisioned, and shutting down."
echo "Please attach Docker disk to VM."
echo "********************************"
echo "Root password set to ${PASS}"
echo "********************************"
rm -rf /home/vagrant
rm -rf /var/tmp/*
rm -rf /root/*

mkdir -p /root/.ssh
echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC7zLHVDpjrcOB2oCd1nMGGZcorobosBmANGo3mxwNgzk/ObvSU4Ye9crwVCzIp/OozYS95giNkpC7Kgv9llMCCChOU6/b8MXxblEdUrRrqt5CuXVe5XiM0imRa6jVH6SBymJqL17tcBpi5jVRiwEfM0tw2Ehzg0hh93APRis0bviu5HvvRT3FKg+mczNqdFHJA9oAnP7tYxlELXueyJv3qXEFiVvPppFyMv1vwIh8Sb6SZTnr95KAZjqYKlHig/aQctwp2WYmxVSSd05tDSuvlyrdZ7io86EyczYS6BBpv8gVQRdXB7of+R/XdRTHBGfIiZjYU6AHrePXZIAk51XbX rails-upload-2.pem' > /root/.ssh/authorized_keys
echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPNXnouMxaGRpBdrUxa+T71w3XxudUYzP42A3CzjLTUv sysadmin@cubbington' >> /root/.ssh/authorized_keys
chown root:root /root/.ssh/*
chmod 600 /root/.ssh/*
