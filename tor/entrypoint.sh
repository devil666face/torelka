#!/bin/bash
set -eE
trap 'echo "Error: line: $LINENO: $(sed -n "${LINENO}p" "$0")"; exit 1' ERR

if [ ! -f "/ok" ]; then
	touch /ok
fi

ip ro del default
# set def gate via socks container
ip route add default via "$GATEWAY"

# run tor
tor -f /etc/tor/torrc &
# set def gate via tor proxy :9050
t2s &
# run socks5 proxy server for input
gox &

if [ -z "$1" ]; then
	sleep infinity
else
	exec "$@"
fi
