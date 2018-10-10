#!/bin/bash

set -x
set -e

echo "Installing network filesystem tools"

apt install -y nfs-kernel-server cifs-utils