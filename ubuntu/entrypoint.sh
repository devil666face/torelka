#!/bin/bash

set -eE
trap 'echo "Error: line: $LINENO: $(sed -n "${LINENO}p" "$0")"; exit 1' ERR

if [ ! -f "/ok" ]; then
	# Create ssh config
	mkdir -p /etc/ssh
	if [ ! -f /etc/ssh/sshd_config ]; then
		cat >/etc/ssh/sshd_config <<'EOF'
Port 22
Protocol 2
HostKey /etc/ssh/ssh_host_rsa_key
HostKey /etc/ssh/ssh_host_ecdsa_key
HostKey /etc/ssh/ssh_host_ed25519_key
PasswordAuthentication yes
PermitRootLogin no
UsePAM yes
Subsystem sftp /usr/lib/openssh/sftp-server
EOF
	fi
	sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
	sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config

	ssh-keygen -A >/dev/null 2>&1

	# Create the user account
	if ! id ubuntu >/dev/null 2>&1; then
		groupadd --gid 1020 ubuntu
		useradd --shell /bin/bash --uid 1020 --gid 1020 --groups sudo --password "$(openssl passwd ubuntu)" --create-home --home-dir /home/ubuntu ubuntu
	fi

	touch /ok
fi

ip ro del default
# set def gate via tor container
ip ro add default via 172.20.100.3

# Remove existing sesman/xrdp PID files to prevent rdp sessions hanging on container restart
[ ! -f /var/run/xrdp/xrdp-sesman.pid ] || rm -f /var/run/xrdp/xrdp-sesman.pid
[ ! -f /var/run/xrdp/xrdp.pid ] || rm -f /var/run/xrdp/xrdp.pid
[ -d /run/sshd ] || mkdir -p /run/sshd

# Start xrdp sesman service
/usr/sbin/xrdp-sesman
/usr/sbin/xrdp
/usr/sbin/sshd

if [ -z "$1" ]; then
	sleep infinity
else
	exec "$@"
fi
