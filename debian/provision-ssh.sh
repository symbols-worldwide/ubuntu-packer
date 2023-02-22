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
rm -rf /var/tmp/*
rm -rf /root/*

mkdir -p /root/.ssh
echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC7zLHVDpjrcOB2oCd1nMGGZcorobosBmANGo3mxwNgzk/ObvSU4Ye9crwVCzIp/OozYS95giNkpC7Kgv9llMCCChOU6/b8MXxblEdUrRrqt5CuXVe5XiM0imRa6jVH6SBymJqL17tcBpi5jVRiwEfM0tw2Ehzg0hh93APRis0bviu5HvvRT3FKg+mczNqdFHJA9oAnP7tYxlELXueyJv3qXEFiVvPppFyMv1vwIh8Sb6SZTnr95KAZjqYKlHig/aQctwp2WYmxVSSd05tDSuvlyrdZ7io86EyczYS6BBpv8gVQRdXB7of+R/XdRTHBGfIiZjYU6AHrePXZIAk51XbX rails-upload-2.pem' > /root/.ssh/authorized_keys
echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPNXnouMxaGRpBdrUxa+T71w3XxudUYzP42A3CzjLTUv sysadmin@cubbington' >> /root/.ssh/authorized_keys
echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDin/hmT/lM3tP71f8ANpE3BTUt0ZW+58QJT5/3Qdm9B71nkL5lLLHywns3HTDbrB7PhPklmmUibGIPBTM4aetlvD4VkOM1lfK3PUH2qLIX6SntlM15BXfAlCID5JbRj4QKQ11Ri+5nh2+ewWA5IqDOR2w99Gmnef10W9mLNY361eqNmLznhQQOHUlEyo++ghvLen3/R+jBlANh9uqLjU6nsxNjORDw5O5SxXiDJUW0df8VpmC8bsP6zkSrYvyghMk1GFNlm47Y+bTLmY0IIHk5LL5PMXRQz+9Auy7iRsYFAArc9fRe01u6hnGtCOVlc0+YETOhwg9iKmOKl/5M4HZn4FzQCNi5MqzQSMU6fRFs0oJnWJ2fMN/GYpm2fHOB5R2ZHg51Ull1TrhfQIFi+Cz3nNlFdQKjrfIcNZ0BZHQKFwjzyhpG+8IqlOyEubM8Js//zDJaWj4PprFBmJRWXP2Q8yevrT0Fprb3tyXwgtr4mIqbz+4GjcmgsyrAKoivlLGiiT2lWKokmb6ovWi8J43lirh5YUox/PP7VhK/gV4bVZDRAZIP+wOUjIw9ZlC52Kjjf8b5gAUgzZeeL7G6O1870ev5zfqAezrcn7O+ki7dM7vHvUYovS3LKkFU6ykx/99k86OnEiOsPzovHdWEzxR0WBYtyf5zF21fCJIP5SCgFQ== buildkite@widgit.com' >> /root/.ssh/authorized_keys
chown root:root /root/.ssh/*
chmod 600 /root/.ssh/*

mkdir -p /home/vagrant/.ssh
echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC7zLHVDpjrcOB2oCd1nMGGZcorobosBmANGo3mxwNgzk/ObvSU4Ye9crwVCzIp/OozYS95giNkpC7Kgv9llMCCChOU6/b8MXxblEdUrRrqt5CuXVe5XiM0imRa6jVH6SBymJqL17tcBpi5jVRiwEfM0tw2Ehzg0hh93APRis0bviu5HvvRT3FKg+mczNqdFHJA9oAnP7tYxlELXueyJv3qXEFiVvPppFyMv1vwIh8Sb6SZTnr95KAZjqYKlHig/aQctwp2WYmxVSSd05tDSuvlyrdZ7io86EyczYS6BBpv8gVQRdXB7of+R/XdRTHBGfIiZjYU6AHrePXZIAk51XbX rails-upload-2.pem' > /home/vagrant/.ssh/authorized_keys
echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPNXnouMxaGRpBdrUxa+T71w3XxudUYzP42A3CzjLTUv sysadmin@cubbington' >> /home/vagrant/.ssh/authorized_keys
echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDin/hmT/lM3tP71f8ANpE3BTUt0ZW+58QJT5/3Qdm9B71nkL5lLLHywns3HTDbrB7PhPklmmUibGIPBTM4aetlvD4VkOM1lfK3PUH2qLIX6SntlM15BXfAlCID5JbRj4QKQ11Ri+5nh2+ewWA5IqDOR2w99Gmnef10W9mLNY361eqNmLznhQQOHUlEyo++ghvLen3/R+jBlANh9uqLjU6nsxNjORDw5O5SxXiDJUW0df8VpmC8bsP6zkSrYvyghMk1GFNlm47Y+bTLmY0IIHk5LL5PMXRQz+9Auy7iRsYFAArc9fRe01u6hnGtCOVlc0+YETOhwg9iKmOKl/5M4HZn4FzQCNi5MqzQSMU6fRFs0oJnWJ2fMN/GYpm2fHOB5R2ZHg51Ull1TrhfQIFi+Cz3nNlFdQKjrfIcNZ0BZHQKFwjzyhpG+8IqlOyEubM8Js//zDJaWj4PprFBmJRWXP2Q8yevrT0Fprb3tyXwgtr4mIqbz+4GjcmgsyrAKoivlLGiiT2lWKokmb6ovWi8J43lirh5YUox/PP7VhK/gV4bVZDRAZIP+wOUjIw9ZlC52Kjjf8b5gAUgzZeeL7G6O1870ev5zfqAezrcn7O+ki7dM7vHvUYovS3LKkFU6ykx/99k86OnEiOsPzovHdWEzxR0WBYtyf5zF21fCJIP5SCgFQ== buildkite@widgit.com' >> /home/vagrant/.ssh/authorized_keys
chown vagrant:vagrant /home/vagrant/.ssh/*
chmod 600 /home/vagrant/.ssh/*
