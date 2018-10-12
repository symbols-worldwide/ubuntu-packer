#!/bin/bash

set -x

mkdir -p /tmp/versions

dpkg-query --showformat='${Version}' --show linux-headers-generic > /tmp/versions/ubuntu-sources
dpkg-query --showformat='${Version}' --show docker-ce > /tmp/versions/docker


exit 0
