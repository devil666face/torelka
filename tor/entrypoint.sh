#!/bin/bash

run() {
	local name=$1
	systemd-run --unit="$name" --no-block --service-type=exec "$name"
}

if [ ! -f "/ok" ]; then
	systemctl enable tor --now &&
		touch /ok
fi

ip ro del default
# set def gate via socks container
ip ro add default via 172.20.100.2

# set def gate via tor proxy :9050
run t2s

# run socks5 proxy server for input
run gox
