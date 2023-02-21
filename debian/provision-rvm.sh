#!/bin/bash

#set -e
gpg --keyserver keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB || /bin/true
(\curl -sSL https://get.rvm.io | bash -s stable --ruby) || /bin/true
usermod -a -G rvm root || /bin/true
