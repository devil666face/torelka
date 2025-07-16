#!/bin/bash
if [ ! -f "/ok" ]; then
	echo "init" &&
		systemctl enable tor --now &&
		touch /ok &&
		echo "entrypoint successfull init"
fi
echo "entrypoint already init"
