FROM alpine:latest
LABEL maintainer="martin@sirscythe.net"
# webproc release settings
ENV WEBPROC_URL https://github.com/jpillora/webproc/releases/download/v0.3.0/webproc_0.3.0_linux_armv7.gz
# fetch dnsmasq and webproc binary
RUN apk update \
        && apk --no-cache add dnsmasq \
        && apk add --no-cache --virtual .build-deps curl \
        && curl -sL $WEBPROC_URL | gzip -d - > /usr/local/bin/webproc \
        && chmod +x /usr/local/bin/webproc \
        && apk del .build-deps
#configure dnsmasq
RUN mkdir -p /etc/default/
RUN echo -e "ENABLED=1\nIGNORE_RESOLVCONF=yes" > /etc/default/dnsmasq
COPY dnsmasq.conf /etc/dnsmasq.conf
#run!
ENTRYPOINT ["webproc","-c","/etc/dnsmasq.conf","--","dnsmasq","--no-daemon"]
