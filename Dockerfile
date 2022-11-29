ARG GOLANG_VERSION=1.19.3
ARG ALPINE_VERSION=3.16

FROM golang:${GOLANG_VERSION}-alpine${ALPINE_VERSION} as gobuild
ARG GOLANG_VERSION
ARG ALPINE_VERSION

WORKDIR /go/src/github.com/caddyserver/xcaddy/cmd/xcaddy

RUN apk add --no-cache git gcc build-base; \
	go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest

RUN  xcaddy build \
	 --output /go/src/github.com/caddyserver/xcaddy/cmd/caddy \
	 --with github.com/lucaslorentz/caddy-docker-proxy/plugin/v2 \
	 --with github.com/caddy-dns/cloudflare

FROM alpine:${ALPINE_VERSION}

ARG GOLANG_VERSION
ARG ALPINE_VERSION

RUN apk add --no-cache ca-certificates curl tzdata; \
             rm -rf /var/cache/apk/*;

LABEL maintainer "HomeAll"

EXPOSE 80 443 2019

ENV XDG_CONFIG_HOME /config

ENV XDG_DATA_HOME /data

COPY --from=gobuild /go/src/github.com/caddyserver/xcaddy/cmd/caddy /bin/

HEALTHCHECK --interval=10s --timeout=5s --start-period=5s CMD curl -fsS http://127.0.0.1:2019/config -o /dev/null || exit 1

ENTRYPOINT ["/bin/caddy"]

CMD ["docker-proxy"]
