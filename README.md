[![Cloudflared](https://github.com/homeall/caddy-reverse-proxy-cloudflare/workflows/CI/badge.svg)](https://github.com/homeall/caddy-reverse-proxy-cloudflare/actions)
![Trivy Workflow Status](https://github.com/homeall/caddy-reverse-proxy-cloudflare/actions/workflows/security-scan.yml/badge.svg?branch=main)
[![Docker](https://img.shields.io/badge/Docker-2496ED?logo=docker&logoColor=fff)](#) 
[![Docker pulls](https://img.shields.io/docker/pulls/homeall/caddy-reverse-proxy-cloudflare)](https://img.shields.io/docker/pulls/homeall/caddy-reverse-proxy-cloudflare)
[![Docker Image Size](https://img.shields.io/docker/image-size/homeall/caddy-reverse-proxy-cloudflare/latest)](https://hub.docker.com/r/homeall/caddy-reverse-proxy-cloudflare)
[![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-2088FF?logo=github-actions&logoColor=white)](#) 
[![Cloudflare](https://img.shields.io/badge/Cloudflare-F38020?logo=Cloudflare&logoColor=white)](#) 
[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2Fhomeall%2Fcaddy-reverse-proxy-cloudflare.svg?type=shield&issueType=license)](https://app.fossa.com/projects/git%2Bgithub.com%2Fhomeall%2Fcaddy-reverse-proxy-cloudflare?ref=badge_shield&issueType=license)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat)](https://ionut.vip)


# Caddy reverse proxy with cloudflare plugin

## Forked from homeall - go buy him a coffee
Enjoying the caffeine boost? If this repo saves you some time, [buy me a coffee](https://buymeacoffee.com/homeall)!
[![Buy Me A Coffee](https://img.shields.io/badge/Buy%20Me%20a%20Coffee-yellow?logo=buymeacoffee&logoColor=white)](https://buymeacoffee.com/homeall)

<!-- ABOUT THE PROJECT -->
## About The Project

Homeall did most of the hard work--I just reduced the plugin selection. 

This docker image enhances the work from [@lucaslorentz](https://github.com/lucaslorentz/caddy-docker-proxy) by bundling several useful plugins:
* **[caddy-docker-proxy](https://github.com/lucaslorentz/caddy-docker-proxy)** – auto-configure Caddy from container labels.
* **[caddy-dynamicdns](https://github.com/mholt/caddy-dynamicdns)** – updates DNS records when your IP changes.
~~* **[sablier](https://github.com/sablierapp/sablier)** – start workloads on demand and stop them when idle.~~

~~* **[CrowdSec bouncer](https://github.com/hslatman/caddy-crowdsec-bouncer)** – block malicious traffic via CrowdSec (HTTP/AppSec/Layer4).~~

~~* **[caddy-admin-ui](https://github.com/gsmlg-dev/caddy-admin-ui)** – experimental web UI for administration.~~

~~* **[caddy-storage-redis](https://github.com/pberkel/caddy-storage-redis)** – store certificates in Redis for clustered setups.~~

~~* **[Cloudflare DNS](https://github.com/caddy-dns/cloudflare)** – handle ACME DNS challenges through Cloudflare.~~

~~* **[transform-encoder](https://github.com/caddyserver/transform-encoder)** – additional compression encoders.~~

~~* **[caddy-ratelimit](https://github.com/mholt/caddy-ratelimit)** – simple request rate limiting.~~

~~* **[caddy-l4](https://github.com/mholt/caddy-l4)** – layer‑4 (TCP/UDP) features.~~

~~* **[caddy-cloudflare-ip](https://github.com/WeidiDeng/caddy-cloudflare-ip)** – log real client IPs when behind Cloudflare.~~

~~* **[caddy-maxmind-geolocation](https://github.com/porech/caddy-maxmind-geolocation)** – MaxMind GeoIP lookups.~~

~~* **[Coraza WAF](https://github.com/corazawaf/coraza-caddy)** – integrate the Coraza web application firewall.~~

~~* **[caddy-security](https://github.com/greenpau/caddy-security)** – authentication portals and security helpers.~~

~~* **[caddy-websockify](https://github.com/hadi77ir/caddy-websockify)** – proxy and translate WebSockets.~~


The image uses a **distroless** base for a smaller footprint and improved security. Caddy and its plugins are refreshed automatically by GitHub Actions, so you always get the latest stable versions.

:notebook_with_decorative_cover: For detailed guidance on using the base caddy-docker-proxy functionality, refer to the [original documentation](https://github.com/lucaslorentz/caddy-docker-proxy).

This image is ideal for using :tm: [Caddy](https://caddyserver.com/) as a reverse proxy with [Let's Encrypt](https://letsencrypt.org/) and [Cloudflare DNS](https://www.cloudflare.com/dns/).

GitHub Actions automatically update the Docker image weekly, including Caddy and all plugins.

It also supports dynamic IP address updates via [Caddy DynamicDNS](https://github.com/mholt/caddy-dynamicdns).

:interrobang: Note: A **scoped API token** is required for Cloudflare DNS. Details can be found [here](https://github.com/libdns/cloudflare#authenticating).


<!-- GETTING STARTED -->
## Getting Started

Check the OG repo for more
