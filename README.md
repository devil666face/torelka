```bash
sysctl -w net.ipv4.ip_forward=1
```

# Run

```bash
docker compose up --build --force-recreate -d
```

# Configure your network

`default gateway` - `172.20.100.3`
`dns` - `172.20.100.3`

# Check for all works correctly (or use this proxy)

1. 127.0.0.1:1081 - proxy to socks

```bash
curl -x socks5h://4ViGK3rkAa:ZSLgI6CSH0@127.0.0.1:1081 'https://check.torproject.org/api/ip'

{"IsTor":false,"IP":"1.3.3.7"} - return your socks5 server address
```

2. 127.0.0.1:1080 - full proxy (tor->socks->wan)

```bash
curl -x socks5h://4ViGK3rkAa:ZSLgI6CSH0@127.0.0.1:1080 'https://check.torproject.org/api/ip'

{"IsTor":true,"IP":"185.241.208.206"} - return random tor address
```

# Use with docker container

```bash
docker run --rm --privileged -it --network torelka rust:latest bash
apt update && apt-get install iproute2 --yes
ip ro del default
ip ro add default via 172.20.100.3 dev eth0
echo "nameserver 172.20.100.3" > /etc/resolv.conf
```

---

```bash
curl -x socks5h://127.0.0.1:9050 'https://check.torproject.org/api/ip' | grep -qm1 -E '"IsTor"\s*:\s*true'
```
