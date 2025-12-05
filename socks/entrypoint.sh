#!/bin/bash

run() {
	local name=$1
	systemd-run --unit="$name" --no-block --service-type=exec "$name"
}

if [ ! -f "/ok" ]; then
	touch /ok
fi

# set def gate via socks5 proxy
run t2s

# run socks5 proxy server for input
run gox
