[![cloudflared](https://github.com/homeall/caddy-reverse-proxy-cloudflare/workflows/CI/badge.svg)](https://github.com/homeall/caddy-reverse-proxy-cloudflare/actions) [![pull](https://img.shields.io/docker/pulls/homeall/caddy-reverse-proxy-cloudflare)](https://img.shields.io/docker/pulls/homeall/caddy-reverse-proxy-cloudflare) [![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-2088FF?logo=github-actions&logoColor=white)](#) [![Docker](https://img.shields.io/badge/Docker-2496ED?logo=docker&logoColor=fff)](#) [![Alpine Linux](https://img.shields.io/badge/Alpine%20Linux-0D597F?logo=alpinelinux&logoColor=fff)](#) [![Cloudflare](https://img.shields.io/badge/Cloudflare-F38020?logo=Cloudflare&logoColor=white)](#)
[![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat)](https://ionut.vip)


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

This docker image enhances the work from [@lucaslorentz](https://github.com/lucaslorentz/caddy-docker-proxy) by including additional Caddy plugins:
*   **[Cloudflare DNS](https://github.com/caddy-dns/cloudflare)**: For DNS challenges, especially for wildcard domains.
*   **[caddy-admin-ui](https://github.com/LXFN/caddy-admin-ui)**: Provides a web interface for Caddy administration (experimental).
*   **[caddy-storage-redis](https://github.com/gamalan/caddy-storage-redis)**: Enables Redis for Caddy's storage, useful for distributed setups.

The image is built on **Caddy v2.10.0** and **Alpine Linux v3.21**. It uses a **distroless base image** for a smaller footprint and improved security. This means the image contains only the Caddy binary and its dependencies, without a shell or other common utilities. For most users, this has no direct impact, but it's something to be aware of if you try to `docker exec` into the container for debugging.

:notebook_with_decorative_cover: For detailed guidance on using the base caddy-docker-proxy functionality, refer to the [original documentation](https://github.com/lucaslorentz/caddy-docker-proxy).

This image is ideal for using :tm: [Caddy](https://caddyserver.com/) as a reverse proxy with [Let's Encrypt](https://letsencrypt.org/) and [Cloudflare DNS](https://www.cloudflare.com/dns/).

GitHub Actions automatically update the Docker image weekly, including Caddy and all plugins.

It also supports dynamic IP address updates via [Caddy DynamicDNS](https://github.com/mholt/caddy-dynamicdns).

:interrobang: Note: A **scoped API token** is required for Cloudflare DNS. Details can be found [here](https://github.com/libdns/cloudflare#authenticating).


<!-- GETTING STARTED -->
## Getting Started

:beginner: This image supports `linux/amd64`, `linux/arm`, and `linux/arm64` architectures, making it suitable for standard Linux servers and various ARM-based devices, including Raspberry Pi.

### Prerequisites

[![Made with Docker !](https://img.shields.io/badge/Made%20with-Docker-blue)](https://github.com/homeall/caddy-reverse-proxy-cloudflare/blob/main/Dockerfile)

You will need to have:

* :whale: [Docker](https://docs.docker.com/engine/install/)
* :whale2: [docker-compose](https://docs.docker.com/compose/) 
* Domain name -> you can get from [Name Cheap](https://www.namecheap.com)
* [Cloudflare DNS Zone](https://www.cloudflare.com/en-gb/learning/dns/glossary/dns-zone/)

<!-- USAGE -->
## Usage

### Docker Compose

:warning: You will have to use **labels** in docker-compose deployment. Please review below what it means each [label](https://caddyserver.com/docs/caddyfile/directives/tls). :arrow_down:

You will tell :tm: [Caddy](https://caddyserver.com/) where it has to route traffic in docker network, as :tm: [Caddy](https://caddyserver.com/) is **ingress** on this case. 

:arrow_down: A simple [docker-compose.yml](https://docs.docker.com/compose/):

```
version: "3.3"

services:
  caddy:
    container_name: caddy
    image: homeall/caddy-reverse-proxy-cloudflare:latest
    restart: unless-stopped
    environment:
      TZ: 'Europe/London'
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock"      # needs socket to read events
      - "./caddy-data:/data"                             # needs volume to back up certificates
    ports:
      - "80:80"
      - "443:443"
      - "443:443/udp"                                    # Enable HTTP/3
    labels:                                              # Global options
      caddy.email: email@example.com                     # needs for acme CERT registration account
      caddy.acme_dns: "cloudflare $API_TOKEN"            # When set here, you don't need to set it for each service individually
      # Optional: Enable Admin UI (experimental) - see section below for more details
      # caddy.admin: "0.0.0.0:2019" 
      # caddy.admin.origins: "your.admin.domain.com" # Or use specific IP/host if not exposing publicly

  whoami0:
    container_name: whoami # Corrected typo from whoiam to whoami
    image: traefik/whoami # Using traefik/whoami as jwilder/whoami is a bit old
    hostname: TheDocker #----->>Expected result using curl
    restart: unless-stopped
    labels:
      caddy: your.example.com                            # Caddy will route traffic for this domain
      # caddy.tls.ca: "https://acme.zerossl.com/v2/DV90" # Uncomment if you prefer ZeroSSL. Default is Let's Encrypt.
      caddy.reverse_proxy: "{{upstreams 80}}"            # Forward traffic to port 80 of this container (traefik/whoami listens on 80)
      caddy.tls.protocols: "tls1.3"                      # Optional: Enforce TLS 1.3. Default is tls1.2 and tls1.3.
      caddy.tls.ca: "https://acme-staging-v02.api.letsencrypt.org/directory" # For testing. Remove for production.
      caddy.tls.dns: "cloudflare $API_TOKEN"             # (Optional when using global setting) Replace $API_TOKEN with your Cloudflare scoped API token.
```
> Please get your scoped API-Token from  **[here](https://github.com/libdns/cloudflare#authenticating)**.

---

### <img src="https://raw.githubusercontent.com/LXFN/caddy-admin-ui/main/static/img/logo_64.png" width="20" height="20"> Caddy Admin UI (Experimental)

The `caddy-admin-ui` plugin provides a web interface for managing Caddy. 
To enable it, you can add the following global labels to your Caddy service in `docker-compose.yml`:

```yaml
    labels:
      # ... other global labels ...
      caddy.admin: "0.0.0.0:2019"                             # Listen address for the admin API & UI
      caddy.admin.origins: "your.admin.domain.com"            # Allowed Host header for accessing the UI (replace with your domain or IP)
      # caddy.admin.enforce_origin: "true"                    # Optional: Enforce origin check
      # caddy.admin.instance_id: "my-caddy-instance"          # Optional: Custom instance ID
```

Then, configure a Caddy service to reverse proxy to the admin UI:

```yaml
  caddy-admin-ui:
    image: homeall/caddy-reverse-proxy-cloudflare:latest # Use the same image
    # This service doesn't run Caddy itself, but its labels are read by the main Caddy instance
    # to set up the reverse proxy for the admin UI.
    # No need to define ports, volumes, or environment for this "proxy definition" service.
    labels:
      caddy: admin.your.example.com  # Domain for accessing the Admin UI
      caddy.reverse_proxy: "{{upstreams host=caddy port=2019}}" # Proxy to the main Caddy admin API
      # Ensure you have appropriate TLS settings, e.g., via global acme_dns or specific labels here
      # caddy.tls.dns: "cloudflare $API_TOKEN" 
```

:warning: **Security Note**: Exposing the Caddy admin interface publicly can be a security risk. Ensure you understand the implications and secure it appropriately (e.g., using strong authentication, IP whitelisting, or running it on a private network). The plugin is also experimental.

---

### <img src="https://avatars.githubusercontent.com/u/7040912?s=200&v=4" width="20" height="20"> Caddy Storage Redis

The `caddy-storage-redis` plugin allows Caddy to use Redis for storing certificates and other state. This is particularly useful in a distributed setup where multiple Caddy instances need to share this information.

Configuration for `caddy-storage-redis` is done within the Caddyfile's global options, specifically in the `storage` block. Environment variables are not used for this plugin.

Here is an example Caddyfile configuration for Redis storage:

```caddyfile
{
    # All values are optional, below are the defaults
    storage redis {
        host           127.0.0.1
        port           6379
        address        127.0.0.1:6379 // derived from host and port values if not explicitly set
        username       ""
        password       ""
        db             0
        timeout        5
        key_prefix     "caddy"
        encryption_key ""    // default no encryption; enable by specifying a secret key containing 32 characters (longer keys will be truncated)
        compression    false // default no compression; if set to true, stored values are compressed using "compress/flate"
        tls_enabled    false
        tls_insecure   true
    }
}

:443 {
    # Your site configuration
    # e.g., reverse_proxy / your-app:port
}
```

:information_source: **Note:** The example above shows the default values for the Redis storage module. If your Redis instance is running on a different server or requires authentication, you will need to update the `host`, `port`, `address` (if not using default host/port), `username`, `password`, and `tls_enabled` fields accordingly.

You'll also need a Redis instance running and accessible by Caddy. Here's a simple example of adding a Redis service to your `docker-compose.yml` if you don't have one already:

```yaml
services:
  # ... your caddy service ...

  redis:
    image: redis:alpine
    container_name: redis
    restart: unless-stopped
    volumes:
      - "./redis-data:/data" # Persist Redis data
    # For production, set a password:
    # command: redis-server --requirepass your-strong-password
```
If you set a password for Redis, ensure you configure it in your Caddyfile's `storage redis` block.
To use the Caddyfile method for configuration, you would typically mount your Caddyfile into the Caddy container. For example, in your `docker-compose.yml`:

```yaml
services:
  caddy:
    container_name: caddy
    image: homeall/caddy-reverse-proxy-cloudflare:latest
    restart: unless-stopped
    environment:
      TZ: 'Europe/London'
      # CADDY_DOCKER_CADDYFILE_PATH: '/path/to/your/Caddyfile' # If using a Caddyfile instead of labels for main config
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock"
      - "./caddy-data:/data"
      - "./my-caddyfile:/etc/caddy/Caddyfile" # Mount your Caddyfile here
    ports:
      - "80:80"
      - "443:443"
      - "443:443/udp"
    # labels for caddy-docker-proxy are still useful for other services, 
    # but storage is configured in the Caddyfile.
    # labels:
    #   caddy.email: email@example.com
    #   caddy.acme_dns: "cloudflare $API_TOKEN" 
```
Ensure that `CADDY_DOCKER_CADDYFILE_PATH` environment variable is **not set** or is pointing to the Caddyfile you are providing if you want Caddy Docker Proxy to use your Caddyfile for the main configuration. If `CADDY_DOCKER_CADDYFILE_PATH` is set, Caddy Docker Proxy will generate a Caddyfile and your storage configuration might be overwritten unless it's also managed by labels (which is not the case for `caddy-storage-redis`).
For `caddy-storage-redis` specifically, the configuration must be in the global options of your main Caddyfile as shown above.


:arrow_up: [Go on TOP](#about-the-project) :point_up:

### Testing

:arrow_down: Your can run the following command to see that is working:
 
```
$  curl --insecure -vvI https://your.example.com 2>&1 | awk 'BEGIN { cert=0 } /^\* Server certificate:/ { cert=1 } /^\*/ { if (cert) print }'
* Server certificate:
*  subject: CN=your.example.com 
*  start date: <Date specific to your test>
*  expire date: <Date specific to your test>
*  issuer: CN=Fake LE Intermediate X1 # This indicates staging/test certificate
*  SSL certificate verify result: unable to get local issuer certificate (20), continuing anyway.
* Using HTTP2, server supports multi-use
* Connection state changed (HTTP/2 confirmed)
* Copying HTTP/2 data in stream buffer to connection buffer after upgrade: len=0
* Using Stream ID: 1 (easy handle <some_hex_value>)
* TLSv1.3 (IN), TLS handshake, Newsession Ticket (4):
* Connection state changed (MAX_CONCURRENT_STREAMS == 250)!
$  curl -k https://your.example.com
I'm TheDocker
```
Make sure to replace `your.example.com` with the domain you configured in the `whoami` service labels. The output `I'm TheDocker` comes from the `hostname` set in the `whoami` service. If you used `traefik/whoami` on port 80, it will output its own identifying information.

![](./assets/caddy-reverse-proxy.gif)

## License

:newspaper_roll: Check the [LICENSE](https://raw.githubusercontent.com/homeall/caddy-reverse-proxy-cloudflare/main/LICENSE) for more information.

<!-- CONTACT -->
## Contact

:red_circle: Please free to open a ticket on Github.

<!-- ACKNOWLEDGEMENTS -->
## Acknowledgements

 * :tada: [@lucaslorentz](https://github.com/lucaslorentz/caddy-docker-proxy) for the original caddy-docker-proxy :trophy:
 * :tada: The :tm: [@Caddy](https://github.com/caddyserver/caddy) team and community :1st_place_medal:
 * :tada: [caddy-dns/cloudflare](https://github.com/caddy-dns/cloudflare) for the Cloudflare DNS plugin :medal_sports:
 * :tada: [@LXFN](https://github.com/LXFN) for the [caddy-admin-ui](https://github.com/LXFN/caddy-admin-ui) plugin :medal_sports:
 * :tada: [@gamalan](https://github.com/gamalan) for the [caddy-storage-redis](https://github.com/gamalan/caddy-storage-redis) plugin :medal_sports:

:arrow_up: [Go on TOP](#about-the-project) :point_up:
