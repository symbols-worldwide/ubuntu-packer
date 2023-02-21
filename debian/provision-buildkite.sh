#!/bin/bash

set -e

cat > /usr/local/bin/run-buildkite.sh <<EOF
#!/bin/bash

export HOME=/root
export TOKEN="faaa75f9c231a01bb614860fd57098a7a34a57eedc6165f657"
if [ ! -d /root/.buildkite-agent/bin ]; then
  curl -sL https://raw.githubusercontent.com/buildkite/agent/master/install.sh | bash
fi

LOCAL_IP=\$(ip route get 8.8.8.8 | head -1 | cut -d' ' -f7)

~/.buildkite-agent/bin/buildkite-agent start \
  --tags 'vagrant=true' \
  --tags 'packer=true' \
  --tags 'virtualbox=true' \
  --tags 'vmware=true' \
  --tags 'linux=true' \
  --tags 'ubuntu=true' \
  --tags "ipaddr=\$LOCAL_IP" \
  --git-clean-flags '-fdx'
EOF

chmod +x /usr/local/bin/run-buildkite.sh

cat > /etc/systemd/system/buildkite.service <<EOF
[Unit]
Description=Buildkite agent.
Documentation=https://buildkite.com/docs/guides/getting-started
Requires=systemd-networkd.socket
After=systemd-networkd.socket
Wants=network-online.target

[Service]
ExecStart=/bin/bash -l /usr/local/bin/run-buildkite.sh
RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable buildkite.service
systemctl enable systemd-networkd-wait-online.service

mkdir -p /root/.buildkite-agent/hooks
cat > /root/.buildkite-agent/hooks/pre-exit <<EOF
#!/bin/bash

# The 'pre-exit' hook will run just before your build job finishes

git clean -fdqx
docker ps -qa | xargs docker rm -f
docker system prune --all --force --volumes
EOF

chmod +x /root/.buildkite-agent/hooks/pre-exit

