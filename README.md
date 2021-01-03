[![cloudflared](https://github.com/homeall/caddy-reverse-proxy-cloudflare/workflows/CI/badge.svg)](https://github.com/homeall/caddy-reverse-proxy-cloudflare/actions) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT) [![pull](https://img.shields.io/docker/pulls/homeall/caddy-reverse-proxy-cloudflare)](https://img.shields.io/docker/pulls/homeall/caddy-reverse-proxy-cloudflare) [![pull](https://img.shields.io/docker/image-size/homeall/caddy-reverse-proxy-cloudflare)](https://img.shields.io/docker/image-size/homeall/caddy-reverse-proxy-cloudflare)

# Caddy reverse proxy with cloudflare plugin

<!-- TABLE OF CONTENTS -->
<details open="open">
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
      </ul>
    </li>
    <li>
      <a href="#usage">Usage</a>
      <ul>
        <li><a href="#docker-compose">Docker-compose</a></li>
      </ul>
        <ul>
        <li><a href="#testing">Testing</a></li>
      </ul>
    </li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgements">Acknowledgements</a></li>
  </ol>
</details>

<!-- ABOUT THE PROJECT -->
## About The Project

:white_check_mark: This docker image is based on work from [@lucaslorentz](https://github.com/lucaslorentz/caddy-docker-proxy) which I included the [plugin Cloudflare](https://github.com/caddy-dns/cloudflare). 

:o: This is only difference between this one and his image. 

:notebook_with_decorative_cover: If you need more details about how to use this image I will adivce you to go on his GitHub and review the [documentation](https://github.com/lucaslorentz/caddy-docker-proxy).

:biohazard: It is useful if you are planning to use the reverse proxy from :tm: [Caddy](https://caddyserver.com/) together with [Let's Encrypt](https://letsencrypt.org/) and [Cloudflare DNS](https://www.cloudflare.com/dns/) as a challenge. 

:star_of_david: The main purpose of creating this image is to have DNS chalange for **wildcard domains**. 

:trident: I am using GitHub Actions where weekly it will update docker image and both plugins.

:interrobang: Note: you will need **the scoped API token** for this setup. Please analyze this **[link](https://github.com/libdns/cloudflare#authenticating)**.

:arrow_up: [Go on TOP](#about-the-project) :point_up:

<!-- GETTING STARTED -->
## Getting Started

:beginner: It will work on any Linux box amd64 or [Raspberry Pi](https://www.raspberrypi.org) with arm64 or arm32. 

### Prerequisites

:eight_spoked_asterisk: You will need to have:

* :whale: [Docker](https://docs.docker.com/engine/install/)
* :whale2: [docker-compose](https://docs.docker.com/compose/) 

:arrow_up: [Go on TOP](#about-the-project) :point_up:

<!-- USAGE -->
## Usage

:beginner: It will work on any Linux box amd64 or [Raspberry Pi](https://www.raspberrypi.org) with arm64 or arm32. 

### Docker Compose

:warning: You will have to use **labes** in docker-compose deployment. 

:radioactive: You will tell :tm: [Caddy](https://caddyserver.com/) where it has to route traffic in docker network, as :tm: [Caddy](https://caddyserver.com/) is **ingress** on this case. 

:arrow_down: A simple [docker-compose.yml](https://docs.docker.com/compose/):


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
    hostname: YourBigBoss ##Expected result using curl
    restart: unless-stopped
    labels:
      caddy: your.example.com
      caddy.reverse_proxy: "{{upstreams 8000}}"
      caddy.tls.protocols: "tls1.3"
      caddy.tls.ca: "https://acme-staging-v02.api.letsencrypt.org/directory" # Needed only for testing purpose. Remove this line after you finished your tests.
      caddy.tls.dns: "cloudflare $API-TOKEN"
```
### Testing

:8ball: You can run command `curl -kivL -H 'Host: your.example.com' 'https://localhost'`

:arrow_down: Output results:

```*   Trying ::1:80...
* Connected to localhost (::1) port 80 (#0)
> GET / HTTP/1.1
> Host: your.example.com
> User-Agent: curl/7.74.0
> Accept: */*
>
* Mark bundle as not supporting multiuse
< HTTP/1.1 308 Permanent Redirect
HTTP/1.1 308 Permanent Redirect
< Connection: close
Connection: close
< Location: https://your.example.com/
Location: https://your.example.com/
< Server: Caddy
Server: Caddy
< Date: Sun, 03 Jan 2021 18:15:19 GMT
Date: Sun, 03 Jan 2021 18:15:19 GMT
< Content-Length: 0
Content-Length: 0

<
* Closing connection 0
* Issue another request to this URL: 'https://your.example.com/'
*   Trying 127.0.0.1:443...
* Connected to test.gonl.ink (127.0.0.1) port 443 (#1)
* ALPN, offering h2
* ALPN, offering http/1.1
* TLSv1.3 (OUT), TLS handshake, Client hello (1):
* TLSv1.3 (IN), TLS handshake, Server hello (2):
* TLSv1.3 (IN), TLS handshake, Encrypted Extensions (8):
* TLSv1.3 (IN), TLS handshake, Certificate (11):
* TLSv1.3 (IN), TLS handshake, CERT verify (15):
* TLSv1.3 (IN), TLS handshake, Finished (20):
* TLSv1.3 (OUT), TLS change cipher, Change cipher spec (1):
* TLSv1.3 (OUT), TLS handshake, Finished (20):
* SSL connection using TLSv1.3 / TLS_AES_128_GCM_SHA256
* ALPN, server accepted to use h2
* Server certificate:
*  subject: CN=your.example.com ## CA from Let's Enctrypt Stagging 
*  start date: Jan  3 17:10:09 2021 GMT
*  expire date: Apr  3 17:10:09 2021 GMT
*  issuer: CN=Fake LE Intermediate X1. ##----> This is telling you that acme is working as expecting!
*  SSL certificate verify result: unable to get local issuer certificate (20), continuing anyway.
* Using HTTP2, server supports multi-use
* Connection state changed (HTTP/2 confirmed)
* Copying HTTP/2 data in stream buffer to connection buffer after upgrade: len=0
* Using Stream ID: 1 (easy handle 0x7fa754813e00)
> GET / HTTP/2
> Host: your.example.com
> user-agent: curl/7.74.0
> accept: */*
>
* TLSv1.3 (IN), TLS handshake, Newsession Ticket (4):
* Connection state changed (MAX_CONCURRENT_STREAMS == 250)!
< HTTP/2 200
HTTP/2 200
< content-type: text/plain; charset=utf-8
content-type: text/plain; charset=utf-8
< date: Sun, 03 Jan 2021 18:15:19 GMT
date: Sun, 03 Jan 2021 18:15:19 GMT
< server: Caddy
server: Caddy
< content-length: 17
content-length: 17

<
I'm YourBigBoss. ##-> Reply from whoiam container.
* Connection #1 to host your.example.com left intact
```

:arrow_up: [Go on TOP](#about-the-project) :point_up:

<!-- LICENSE -->
## License

:newspaper_roll: Distributed under the MIT license. See [LICENSE](https://raw.githubusercontent.com/homeall/caddy-reverse-proxy-cloudflare/main/LICENSE) for more information.

:arrow_up: [Go on TOP](#about-the-project) :point_up:

<!-- CONTACT -->
## Contact

:red_circle: Please free to open a ticket on Github.

:arrow_up: [Go on TOP](#about-the-project) :point_up:

<!-- ACKNOWLEDGEMENTS -->
## Acknowledgements

 * :tada: [@lucaslorentz](https://github.com/lucaslorentz/caddy-docker-proxy) :trophy:
 * :tada: :tm: [@Caddy](https://github.com/caddyserver/caddy) :1st_place_medal: and its huge :medal_military: **community** :heavy_exclamation_mark:
 * :tada: [dns.providers.cloudflare](https://github.com/caddy-dns/cloudflare) :medal_sports:

:arrow_up: [Go on TOP](#about-the-project) :point_up:
