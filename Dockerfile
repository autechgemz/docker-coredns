FROM debian:buster
ENV TZ Asia/Tokyo
ENV GOPATH /go
ARG TIMEZONE=${TZ}
ARG COREDNS_VERSION=1.6.2
RUN ln -snf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
 && apt-get update \
 && apt-get install --no-install-recommends -y \
    procps \
    tini \
    dnsutils \
    curl \
    ca-certificates \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && mkdir -p $GOPATH \
 && mkdir -p $GOPATH/bin \
 && mkdir -p $GOPATH/etc \
 && curl -L https://github.com/coredns/coredns/releases/download/v${COREDNS_VERSION}/coredns_${COREDNS_VERSION}_linux_amd64.tgz | tar zx -C ${GOPATH}/bin/ \
 && chmod +x ${GOPATH}/bin/coredns
COPY Corefile ${GOPATH}/etc/Corefile
COPY entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh
EXPOSE 53/tcp 53/udp
ENTRYPOINT ["tini", "--"]
CMD ["/entrypoint.sh"]
COPY Dockerfile /Dockerfile
