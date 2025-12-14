#!/bin/bash
set -eE
trap 'echo "Error: line: $LINENO: $(sed -n "${LINENO}p" "$0")"; exit 1' ERR

if [ ! -f "/ok" ]; then
	touch /ok
fi

# set def gate via socks5 proxy
t2s &
# run socks5 proxy server for input
gox &

if [ -z "$1" ]; then
	sleep infinity
else
	exec "$@"
fi
