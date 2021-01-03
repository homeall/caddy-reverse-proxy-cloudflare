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
    restart: unless-stopped
    labels:
      caddy: your.example.com
      caddy.reverse_proxy: "{{upstreams 8000}}"
      caddy.tls.protocols: "tls1.3"
      caddy.tls.ca: "https://acme-staging-v02.api.letsencrypt.org/directory" # Needed only for testing purpose. Remove this line after you finished your tests.
      caddy.tls.dns: "cloudflare $API-TOKEN"
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
