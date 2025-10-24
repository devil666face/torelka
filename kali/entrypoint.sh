#!/bin/bash

run() {
	local name=$1
	systemd-run --unit=$name --no-block --service-type=exec $name
}

if [ ! -f "/ok" ]; then
	useradd -m -s /bin/bash -p "${KALI_HASH}" kali

	# Ensure XDG base directories and default user-places file for Dolphin/Plasma
	mkdir -p /home/kali/.local/share \
		/home/kali/.config \
		/home/kali/.cache
	if [ ! -s /home/kali/.local/share/user-places.xbel ]; then
		cat >/home/kali/.local/share/user-places.xbel <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<xbel version="1.0">
  <folder folded="no"><title>Places</title></folder>
  <!-- Initialized by container startup -->
</xbel>
EOF
	fi

	printf '%s\n%s\n' "setxkbmap -layout us,ru -option grp:alt_shift_toggle" "exec startplasma-x11" >/home/kali/.xsession

	chown -R kali:kali /home/kali

	# Ensure XRDP listens on TCP and all interfaces
	awk 'BEGIN{in_g=0} \
    /^\[Globals\]/{in_g=1} \
    /^\[.*\]/{if($0!~"^\\[Globals\\]") in_g=0} \
    { \
      if(in_g && $0 ~ /^use_vsock=/){$0="use_vsock=false"} \
      if(in_g && $0 ~ /^#?address=/){$0="address=0.0.0.0"} \
      if(in_g && $0 ~ /^port=/){$0="port=3389"} \
      print \
    }' /etc/xrdp/xrdp.ini >/etc/xrdp/xrdp.ini.tmp &&
		mv /etc/xrdp/xrdp.ini.tmp /etc/xrdp/xrdp.ini &&
		sed -i '/^\[Xorg\]/,/^\[/{s/^lib=.*/lib=libxup.so/; s/^port=.*/port=-1/; s/^ip=.*/ip=127.0.0.1/}' /etc/xrdp/xrdp.ini &&
		printf 'allowed_users=anybody\n' >/etc/Xwrapper.config

	getent group rdpusers >/dev/null || groupadd rdpusers
	usermod -aG rdpusers 'kali'
	if ! grep -q 'pam_succeed_if.so.*ingroup rdpusers' /etc/pam.d/xrdp-sesman 2>/dev/null; then
		sed -i '1i auth required pam_succeed_if.so user ingroup rdpusers' /etc/pam.d/xrdp-sesman
	fi
	touch /ok
fi

ip ro del default via 172.20.100.1 dev eth0
# set def gate via tor container
ip ro add default via 172.20.100.3 dev eth0

# Start dbus (needed by desktop session)
service dbus start

# Clean up possible stale PID files from previous restarts
mkdir -p /run/xrdp
rm -f /run/xrdp/xrdp.pid \
	/run/xrdp/xrdp-sesman.pid \
	/var/run/xrdp/xrdp.pid \
	/var/run/xrdp/xrdp-sesman.pid

# Restrict XRDP logins to group 'rdpusers' only and add kali to it
/usr/sbin/xrdp-sesman -n &
/usr/sbin/xrdp -n

sleep infinity
