```bash
sysctl -w net.ipv4.ip_forward=1
```

# Configure your network

`default gateway` - `172.17.0.3`
`dns` - `172.17.0.3`

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

---

```bash
curl -x socks5h://127.0.0.1:9050 'https://check.torproject.org/api/ip' | grep -qm1 -E '"IsTor"\s*:\s*true'
```
