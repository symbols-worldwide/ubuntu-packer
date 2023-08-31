https://github.com/symbols-worldwide/ubuntu-packer.git#!/bin/bash

set -e

# Vagrant do not provide a "latest" link on the grounds that you can "easily" just parse the HTML output of the download directory.
# Hashicorp are morons. They also broke this script by releasing a _1 version that is unparseable and removing the previous one.

LATEST_VAGRANT_DIR=`curl -s https://releases.hashicorp.com/vagrant/ | grep href | grep -v '\.\.' | head -1 | cut -d'"' -f2`
LATEST_VAGRANT_PATH=${LATEST_VAGRANT_DIR:1:-1}
LATEST_VAGRANT_VERSION=${LATEST_VAGRANT_PATH#vagrant/}

# curl -s -o vagrant.deb https://releases.hashicorp.com/${LATEST_VAGRANT_PATH}/${LATEST_VAGRANT_PATH/\//_}_x86_64.deb
# Hardcode this for now because, as I may have mentioned, Hashicorp are morons
curl -s -o vagrant.deb https://releases.hashicorp.com/vagrant/2.3.7/vagrant_2.3.7-1_amd64.deb
dpkg -i vagrant.deb
[ ! -e /usr/bin/vagrant ] && ln -s /opt/vagrant/bin/vagrant /usr/bin/vagrant

LATEST_VAGRANT_VMWARE_UTIL_DIR=`curl -s https://releases.hashicorp.com/vagrant-vmware-utility/ | grep href | grep -v '\.\.' | head -1 | cut -d'"' -f2`
LATEST_VAGRANT_VMWARE_UTIL_PATH=${LATEST_VAGRANT_VMWARE_UTIL_DIR:1:-1}
LATEST_VAGRANT_VMWARE_UTIL_VERSION=${LATEST_VAGRANT_VMWARE_UTIL_PATH#vagrant-vmware-utility/}
#curl -s -o vagrant_vmware_utility.deb https://releases.hashicorp.com/vagrant-vmware-utility/${LATEST_VAGRANT_VMWARE_UTIL_VERSION}/vagrant-vmware-utility_${LATEST_VAGRANT_VMWARE_UTIL_VERSION}_x86_64.deb
#
# Have I mentioned that Hashicorp are morons? Hardcoding this _again_.
curl -s -o vagrant_vmware_utility.deb https://releases.hashicorp.com/vagrant-vmware-utility/1.0.22/vagrant-vmware-utility_1.0.22-1_amd64.deb
dpkg -i vagrant_vmware_utility.deb

apt-get install -y pbzip2
