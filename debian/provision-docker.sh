#!/bin/bash

set -e

apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
	pass \
	rng-tools
	
mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
chmod a+r /etc/apt/keyrings/docker.gpg
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
usermod -aG docker root

mkdir -m 0700 -p /etc/docker

cat <<EOF > /etc/docker/daemon.json
{
  "bip": "172.18.64.1/20"
}
EOF

wget -q -O- https://github.com/docker/docker-credential-helpers/releases/download/v0.6.0/docker-credential-pass-v0.6.0-amd64.tar.gz | tar xv -C /usr/local/bin 

cat > /tmp/gpg.tmp <<EOF
Key-Type: default
Subkey-Type: default
Name-Real: buildkite-agent
Name-Email: buildkite@widgit.com
Expire-Date: 0
%no-protection
%commit
EOF
gpg --batch --generate-key /tmp/gpg.tmp

pass init buildkite@widgit.com

mkdir -p /root/.docker <<EOF
cat > /root/.docker/config.json
{
  "credsStore": "pass"
}
EOF
