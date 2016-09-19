[![](https://images.microbadger.com/badges/image/rawmind/rancher-go-dnsmasq.svg)](https://microbadger.com/images/rawmind/rancher-go-dnsmasq "Get your own image badge on microbadger.com")

rancher-go-dnsmasq
==================

This image is the go-dnsmasq dynamic conf for rancher. It comes from [rancher-tools][rancher-tools].

## Build

```
docker build -t rawmind/rancher-go-dnsmasq:<version> .
```

## Versions

- `1.0.6` [(Dockerfile)](https://github.com/rawmind0/rancher-go-dnsmasq/blob/1.0.6/README.md)


## Usage

This image has to be run as a sidekick of [alpine-go-dnsmasq][alpine-go-dnsmasq], and makes available /opt/tools volume. It scans from rancher-metadata, for a skydns services, and generates stub zones and search config dynamicly.


[alpine-go-dnsmasq]: https://github.com/rawmind0/alpine-go-dnsmasq
[rancher-tools]: https://github.com/rawmind0/rancher-tools