#!/bin/bash

set -e

#if [ "x$NEW_HOSTNAME" == "x" ]; then
#  DEFAULT_INT="$(ip route show to default | sed -e's/^.*dev //;s/ .*$//')"
#  MAC_ADDR="$(ip address show $DEFAULT_INT | fgrep 'link/ether' |sed -e 's,^.*link/ether ,,;s/ .*$//;s/://g;')"
#  NEW_HOSTNAME="bk-$MAC_ADDR"
#fi

NEW_HOSTNAME="buildkite-bookworm"

sudo sed -ri \
  's/127\.0\.1\.1.*/127.0.1.1 '$NEW_HOSTNAME' '$NEW_HOSTNAME'.cubbington.eu.widgit.com debian/' \
  /etc/hosts

echo $NEW_HOSTNAME | sudo tee /etc/hostname
sudo hostnamectl set-hostname $NEW_HOSTNAME

