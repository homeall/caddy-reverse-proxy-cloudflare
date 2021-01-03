FROM golang:alpine as gobuild

RUN apk add --no-cache git gcc build-base; \
	go get -v github.com/caddyserver/xcaddy/cmd/xcaddy

WORKDIR /go/src/github.com/caddyserver/xcaddy/cmd/xcaddy

RUN go build ./

RUN  xcaddy build \
	 --output /go/src/github.com/caddyserver/xcaddy/cmd/caddy \
	 --with github.com/lucaslorentz/caddy-docker-proxy/plugin/v2 \
	 --with github.com/caddy-dns/cloudflare

FROM alpine:3.11 as alpine

RUN apk add -U --no-cache ca-certificates curl

LABEL maintainer "HomeAll"

EXPOSE 80 443 2019

ENV XDG_CONFIG_HOME /config

ENV XDG_DATA_HOME /data

COPY --from=gobuild /go/src/github.com/caddyserver/xcaddy/cmd/caddy /bin/

HEALTHCHECK --interval=10s --timeout=5s --start-period=5s CMD curl -fs http://127.0.0.1:2019/config -o /dev/null || exit 1

ENTRYPOINT ["/bin/caddy"]

CMD ["docker-proxy"]
