ARG CADDY_VERSION=2.9.1
ARG ALPINE_VERSION=3.21

FROM caddy:${CADDY_VERSION}-builder AS builder

RUN xcaddy build \
#	 --with github.com/lucaslorentz/caddy-docker-proxy/v2 \
         --with github.com/lucaslorentz/caddy-docker-proxy/v2@7c489f0e193efaf57aaaed07da9cc713c55054d1 \
	 --with github.com/mholt/caddy-dynamicdns \
	 --with github.com/mholt/caddy-ratelimit \
#	 --with github.com/WeidiDeng/caddy-cloudflare-ip \
#	 --with github.com/porech/caddy-maxmind-geolocation \
#	 --with github.com/caddyserver/transform-encoder \
         --with github.com/hslatman/caddy-crowdsec-bouncer/http \
	 --with github.com/hslatman/caddy-crowdsec-bouncer/appsec \
         --with github.com/hslatman/caddy-crowdsec-bouncer/layer4 \
#         --with github.com/corazawaf/coraza-caddy/v2 \
	 --with github.com/pberkel/caddy-storage-redis \
         --with github.com/mholt/caddy-l4 \
         --wwith github.com/hadi77ir/caddy-websockify \
	 --with github.com/caddy-dns/cloudflare

FROM alpine:${ALPINE_VERSION}

RUN apk add --no-cache ca-certificates curl tzdata; \
             rm -rf /var/cache/apk/*;

LABEL maintainer "HomeAll"

EXPOSE 80 443 2019

ENV XDG_CONFIG_HOME /config

ENV XDG_DATA_HOME /data

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

HEALTHCHECK --interval=10s --timeout=5s --start-period=5s CMD curl -fsS http://127.0.0.1:2019/config -o /dev/null || exit 1

ENTRYPOINT ["caddy"]

CMD ["docker-proxy"]
