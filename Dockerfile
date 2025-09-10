ARG CADDY_VERSION=2.10.2
ARG ALPINE_VERSION=3.22.1

# ---- Builder Stage ----
FROM caddy:${CADDY_VERSION}-builder AS builder

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/v2 \
    --with github.com/pberkel/caddy-storage-redis \
    --with github.com/caddy-dns/cloudflare

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
