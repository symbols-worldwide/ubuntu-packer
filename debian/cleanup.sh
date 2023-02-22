#!/bin/bash -eux

apt -y remove --purge ansible

apt -y autoremove --purge
apt-get clean

# Zero out the rest of the free space using dd, then delete the written file.
dd if=/dev/zero of=/EMPTY bs=1M || true
rm -f /EMPTY

# Add `sync` so Packer doesn't quit too early, before the large file is deleted.
sync || /bin/true
