[![cloudflared](https://github.com/homeall/caddy-reverse-proxy-cloudflare/workflows/CI/badge.svg)](https://github.com/homeall/caddy-reverse-proxy-cloudflare/actions) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT) [![pull](https://img.shields.io/docker/pulls/homeall/caddy-reverse-proxy-cloudflare)](https://img.shields.io/docker/pulls/homeall/caddy-reverse-proxy-cloudflare) [![pull](https://img.shields.io/docker/image-size/homeall/caddy-reverse-proxy-cloudflare)](https://img.shields.io/docker/image-size/homeall/caddy-reverse-proxy-cloudflare)

# Caddy reverse proxy with cloudflare plugin

This docker image is based on work from [@lucaslorentz](https://github.com/lucaslorentz/caddy-docker-proxy) which I included the [plugin Cloudflare](https://github.com/caddy-dns/cloudflare).

Please review the *links above* in order to use it. 

It is useful if you are planning to use the reverse proxy from [Caddy](https://caddyserver.com/) together with [Let's Encrypt](https://letsencrypt.org/) and [Cloudflare DNS](https://www.cloudflare.com/dns/) as a challenge. 

Very great for *wildcard domains*. 

Note: you will need **the scoped API token** for this setup. Please analyze this **[link](https://github.com/libdns/cloudflare#authenticating)**.

## Configuration

[docker-compose.yml](https://docs.docker.com/compose/):


```
version: "3.3"

services:

  caddy:
    container_name: caddy
    image: homeall/caddy-reverse-proxy-cloudflare:latest
    restart: unless-stopped
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock" # needs socket to read events
      - "./caddy-data:/data" # needs volume to back up certificates
    ports:
      - "80:80"
      - "443:443"
    labels: # Global options
      caddy.email: email@example.com

  whoami0:
    container_name: whoiam
    image: jwilder/whoami:latest
    restart: unless-stopped
    labels:
      caddy: your.example.com
      caddy.reverse_proxy: "{{upstreams 8000}}"
      caddy.tls.protocols: "tls1.3"
      caddy.tls.ca: "https://acme-staging-v02.api.letsencrypt.org/directory" # Needed only for testing purpose. Remove this line after you finished your tests.
      caddy.tls.dns: "cloudflare $API-TOKEN"
```
### Licence

Distributed under the MIT license.
