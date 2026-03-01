ARG CADDY_VERSION=2.11.1
ARG ALPINE_VERSION=3.23.3

# ---- Builder Stage ----
FROM caddy:${CADDY_VERSION}-builder AS builder

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/v2 \
    --with github.com/mholt/caddy-dynamicdns \
    --with github.com/sablierapp/sablier/plugins/caddy \
    --with github.com/hslatman/caddy-crowdsec-bouncer/http \
    --with github.com/hslatman/caddy-crowdsec-bouncer/appsec \
    --with github.com/gsmlg-dev/caddy-admin-ui@main \
    --with github.com/pberkel/caddy-storage-redis \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/caddyserver/transform-encoder \
    --with github.com/mholt/caddy-ratelimit \
    --with github.com/mholt/caddy-l4 \
    --with github.com/WeidiDeng/caddy-cloudflare-ip \
    --with github.com/porech/caddy-maxmind-geolocation \
    --with github.com/hslatman/caddy-crowdsec-bouncer/layer4 \
    --with github.com/corazawaf/coraza-caddy/v2 \
    --with github.com/greenpau/caddy-security \
#    --with github.com/fabriziosalmi/caddy-waf \
    --with github.com/hadi77ir/caddy-websockify

# Certs stage
FROM alpine:${ALPINE_VERSION} AS certs
RUN apk add --no-cache ca-certificates tzdata

# Final image
FROM gcr.io/distroless/static-debian12:latest

ENV XDG_CONFIG_HOME=/config \
    XDG_DATA_HOME=/data

EXPOSE 80 443 2019 443/udp

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
COPY --from=certs /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=certs /usr/share/zoneinfo /usr/share/zoneinfo

CMD ["caddy", "docker-proxy"]