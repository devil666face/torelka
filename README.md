```bash
curl -x socks5h://127.0.0.1:9050 'https://check.torproject.org/api/ip'
curl -x socks5h://127.0.0.1:9050 'https://check.torproject.org/api/ip' | grep -qm1 -E '"IsTor"\s*:\s*true'
```
