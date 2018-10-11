#!/bin/bash

set -e
set -x

if [ "$PACKER_BUILDER_TYPE" != "virtualbox-iso" ]; then
  exit 0
fi

apt install -y virtualbox virtualbox-dkms