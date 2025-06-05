[![Cloudflared](https://github.com/homeall/caddy-reverse-proxy-cloudflare/workflows/CI/badge.svg)](https://github.com/homeall/caddy-reverse-proxy-cloudflare/actions)
[![Docker](https://img.shields.io/badge/Docker-2496ED?logo=docker&logoColor=fff)](#) 
[![Docker pulls](https://img.shields.io/docker/pulls/homeall/caddy-reverse-proxy-cloudflare)](https://img.shields.io/docker/pulls/homeall/caddy-reverse-proxy-cloudflare)
[![Docker Image Size](https://img.shields.io/docker/image-size/homeall/caddy-reverse-proxy-cloudflare/latest)](https://hub.docker.com/r/homeall/caddy-reverse-proxy-cloudflare)
[![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-2088FF?logo=github-actions&logoColor=white)](#) 
[![Cloudflare](https://img.shields.io/badge/Cloudflare-F38020?logo=Cloudflare&logoColor=white)](#) 
[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2Fhomeall%2Fcaddy-reverse-proxy-cloudflare.svg?type=shield&issueType=license)](https://app.fossa.com/projects/git%2Bgithub.com%2Fhomeall%2Fcaddy-reverse-proxy-cloudflare?ref=badge_shield&issueType=license)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat)](https://ionut.vip)


# Caddy reverse proxy with cloudflare plugin

Enjoying the caffeine boost? If this repo saves you some time, [buy me a coffee](https://buymeacoffee.com/homeall)!
[![Buy Me A Coffee](https://img.shields.io/badge/Buy%20Me%20a%20Coffee-yellow?logo=buymeacoffee&logoColor=white)](https://buymeacoffee.com/homeall)
![Caddy Ultimate Reverse Proxy Banner](./assets/banner.png)
<!-- TABLE OF CONTENTS -->
<details open="open">
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#whats-new">What's New</a>
    </li>
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
          <li><a href="#docker-run">Docker run</a></li>
        </ul>
        <ul>
        <li><a href="#testing">Testing</a></li>
      </ul>
    </li>
    <li><a href="#license">License</a></li>
      <li><a href="#contact">Contact</a></li>
      <li><a href="#support-this-project">Support</a></li>
  </ol>
</details>

## What's New

- Now built on a minimal **distroless** base image.
- Expanded plugin set including rate limiting, Cloudflare IP handling, geolocation, Coraza WAF and more.
- Updated CI workflows and security docs.

<!-- ABOUT THE PROJECT -->
## About The Project

This docker image enhances the work from [@lucaslorentz](https://github.com/lucaslorentz/caddy-docker-proxy) by bundling several useful plugins:
* **[caddy-docker-proxy](https://github.com/lucaslorentz/caddy-docker-proxy)** – auto-configure Caddy from container labels.
* **[caddy-dynamicdns](https://github.com/mholt/caddy-dynamicdns)** – updates DNS records when your IP changes.
* **[sablier](https://github.com/sablierapp/sablier)** – start workloads on demand and stop them when idle.
* **[CrowdSec bouncer](https://github.com/hslatman/caddy-crowdsec-bouncer)** – block malicious traffic via CrowdSec (HTTP/AppSec/Layer4).
* **[caddy-admin-ui](https://github.com/gsmlg-dev/caddy-admin-ui)** – experimental web UI for administration.
* **[caddy-storage-redis](https://github.com/pberkel/caddy-storage-redis)** – store certificates in Redis for clustered setups.
* **[Cloudflare DNS](https://github.com/caddy-dns/cloudflare)** – handle ACME DNS challenges through Cloudflare.
* **[transform-encoder](https://github.com/caddyserver/transform-encoder)** – additional compression encoders.
* **[caddy-ratelimit](https://github.com/mholt/caddy-ratelimit)** – simple request rate limiting.
* **[caddy-l4](https://github.com/mholt/caddy-l4)** – layer‑4 (TCP/UDP) features.
* **[caddy-cloudflare-ip](https://github.com/WeidiDeng/caddy-cloudflare-ip)** – log real client IPs when behind Cloudflare.
* **[caddy-maxmind-geolocation](https://github.com/porech/caddy-maxmind-geolocation)** – MaxMind GeoIP lookups.
* **[Coraza WAF](https://github.com/corazawaf/coraza-caddy)** – integrate the Coraza web application firewall.
* **[caddy-security](https://github.com/greenpau/caddy-security)** – authentication portals and security helpers.
* **[caddy-websockify](https://github.com/hadi77ir/caddy-websockify)** – proxy and translate WebSockets.

The image uses a **distroless** base for a smaller footprint and improved security. Caddy and its plugins are refreshed automatically by GitHub Actions, so you always get the latest stable versions.

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

services:
  caddy:
    container_name: caddy
    image: homeall/caddy-reverse-proxy-cloudflare:latest
    restart: unless-stopped
    environment:
      TZ: 'Europe/London'
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock"      # needs socket to read events
      - "./caddy-data:/data"                             # persist certificates via XDG_DATA_HOME
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
    container_name: whoam
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

### Docker Run

For quick tests without a compose file:

```bash
docker run -d --name caddy \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $(pwd)/caddy-data:/data \
  -e TZ="Europe/London" \
  -p 80:80 -p 443:443 -p 443:443/udp \
  homeall/caddy-reverse-proxy-cloudflare:latest
```

Label your other containers as in the compose example so Caddy can route traffic.

---

### Using a Custom Caddyfile

By default, this image uses `caddy-docker-proxy` to generate Caddy's configuration from Docker labels. However, you can also provide your own complete Caddyfile.

**How Caddy Loads Configuration:**
Caddy itself loads its primary configuration from `/etc/caddy/Caddyfile` by default.

**Role of `caddy-docker-proxy` and Labels:**
The `caddy-docker-proxy` service (which is part of this image's entrypoint logic) monitors Docker events and generates a Caddyfile based on the labels you define on your services. By default, `caddy-docker-proxy` writes this generated Caddyfile to `/etc/caddy/Caddyfile`.

**Providing Your Own Caddyfile (Most Common Method):**
If you want to use your own complete Caddyfile and bypass the label-based generation for the main configuration, mount your custom Caddyfile to `/etc/caddy/Caddyfile`.

Example `docker-compose.yml` snippet:
```yaml
services:
  caddy:
    # ... other caddy service config ...
    image: homeall/caddy-reverse-proxy-cloudflare:latest
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock"  # Still needed if you import label-generated snippets or for other proxy features
      - "./caddy-data:/data"                         # persist certificates via XDG_DATA_HOME
      - "./my-custom-caddyfile:/etc/caddy/Caddyfile" # Mount your custom Caddyfile here
    # environment:
      # CADDY_DOCKER_CADDYFILE_PATH: '/etc/caddy/Caddyfile' # Default path for label-generated config.
                                                            # If you mount to /etc/caddy/Caddyfile, this var is implicitly handled.
    # ...
```
When you mount your own file to `/etc/caddy/Caddyfile`, it takes precedence over the file `caddy-docker-proxy` would generate at that same default location. The image's entrypoint is designed to detect a user-provided Caddyfile at this path and will use it directly.

### Basic Caddyfile Example

Below is a minimal Caddyfile that configures a single domain using the Cloudflare DNS plugin. The Cloudflare API token is read from the `CLOUDFLARE_API_TOKEN` environment variable.

```caddyfile
{
    email you@example.com
    acme_dns cloudflare {env.CLOUDFLARE_API_TOKEN}
}

example.com {
    respond "Hello from Caddy"
}
```

Before running Caddy, ensure the `CLOUDFLARE_API_TOKEN` environment variable is set with a token that has permission to manage your domain's DNS records.

**Advanced: Label-Generated Config to a Different Path (`CADDY_DOCKER_CADDYFILE_PATH`)**
The `CADDY_DOCKER_CADDYFILE_PATH` environment variable tells `caddy-docker-proxy` where it should write the Caddyfile it generates from Docker labels.
*   If you **do not set** `CADDY_DOCKER_CADDYFILE_PATH`, it defaults to `/etc/caddy/Caddyfile`.
*   If you mount your custom Caddyfile to `/etc/caddy/Caddyfile`, `caddy-docker-proxy` will still attempt to write to this path, but your mounted file will be what Caddy uses.
*   **Hybrid Setup (Advanced):** If you want Caddy to load your custom Caddyfile from `/etc/caddy/Caddyfile` but *also* want `caddy-docker-proxy` to generate a separate Caddyfile from labels (e.g., for specific dynamic backends), you can set `CADDY_DOCKER_CADDYFILE_PATH` to a *different* location, for example:
    ```yaml
    environment:
      CADDY_DOCKER_CADDYFILE_PATH: '/caddy-generated/CaddyfileFromLabels'
    volumes:
      - "./my-custom-caddyfile:/etc/caddy/Caddyfile"
      - "./caddy-generated:/caddy-generated" # So you can inspect or use the generated file
    ```
    In this scenario, your custom `/etc/caddy/Caddyfile` would be loaded by Caddy. You could then use the `import /caddy-generated/CaddyfileFromLabels` directive within your custom Caddyfile to include the label-generated configurations. This is useful if you want a base static configuration combined with dynamic configurations from other Docker containers.

**Important Considerations:**
*   If you provide a custom Caddyfile to `/etc/caddy/Caddyfile`, you are fully responsible for its content, including global options, TLS settings, and defining your sites.
*   Plugins like `caddy-storage-redis` require their configuration to be in the global options block of the Caddyfile that Caddy loads (i.e., your custom `/etc/caddy/Caddyfile`).
*   The `caddy.email` and `caddy.acme_dns` labels on the Caddy service itself are typically used by `caddy-docker-proxy` to generate global options. If you provide a full custom Caddyfile, ensure these global options (like `email` for ACME and `acme_dns` for DNS challenges) are correctly defined in your Caddyfile's global block `{...}`.

---

### :construction: Caddy Admin UI (Experimental)

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

:warning: **Security Note**: Exposing the Caddy admin interface publicly can be a security risk. Ensure you understand the implications and secure it appropriately (e.g., using strong authentication, IP whitelisting, or running it on a private network). The plugin is also experimental.

---

### <img src="https://avatars.githubusercontent.com/u/7040912?s=200&v=4" width="20" height="20"> Caddy Storage Redis

The `caddy-storage-redis` plugin allows Caddy to use Redis for storing certificates and other state. This is particularly useful in a distributed setup where multiple Caddy instances need to share this information.

Configuration for `caddy-storage-redis` is done within the global options of your Caddyfile (typically `/etc/caddy/Caddyfile`), specifically in the `storage` block. Environment variables are not directly used for configuring the Redis storage parameters themselves.

Here is an example Caddyfile snippet showing Redis storage configuration:

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

To use a custom Caddyfile (e.g., for configuring Redis storage or other specific settings not covered by labels), mount it to `/etc/caddy/Caddyfile`. See the "Using a Custom Caddyfile" section above for more details.

Example `docker-compose.yml` for Caddy service using a custom Caddyfile for Redis storage:
```yaml
services:
  caddy:
    container_name: caddy
    image: homeall/caddy-reverse-proxy-cloudflare:latest
    restart: unless-stopped
    environment:
      TZ: 'Europe/London'
      # CADDY_DOCKER_CADDYFILE_PATH: '/etc/caddy/Caddyfile' # Default path for label-generated config.
                                                            # When mounting to /etc/caddy/Caddyfile, this is implicitly handled.
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock"  # For caddy-docker-proxy to read service labels
      - "./caddy-data:/data"                         # persist certificates via XDG_DATA_HOME
      - "./my-caddyfile-with-redis-config:/etc/caddy/Caddyfile" # Mount your Caddyfile here
    ports:
      - "80:80"
      - "443:443"
      - "443:443/udp"
    # Docker labels for caddy-docker-proxy (e.g., for other services) can still be used
    # in conjunction with a custom Caddyfile if your custom Caddyfile imports label-generated snippets.
    # However, global options like 'storage' must be in the primary /etc/caddy/Caddyfile.
    # labels:
    #   caddy.email: email@example.com 
    #   caddy.acme_dns: "cloudflare $API_TOKEN"
```
The `caddy-storage-redis` configuration (like the `storage redis { ... }` block) must be in the global options of the Caddyfile that Caddy loads (i.e., `/etc/caddy/Caddyfile` if you've mounted your own).


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

:red_circle: [Open an issue on GitHub](https://github.com/homeall/caddy-reverse-proxy-cloudflare/issues/new/choose) if you run into problems.
## Support this project
If you find this image useful, you can [buy me a coffee](https://buymeacoffee.com/homeall) to help keep development going.

[![Buy Me a Coffee](https://img.buymeacoffee.com/button-api/?text=Buy%20me%20a%20coffee&slug=homeall&button_colour=FFDD00&font_colour=000000&font_family=Arial&outline_colour=000000&coffee_colour=ffffff)](https://buymeacoffee.com/homeall)


