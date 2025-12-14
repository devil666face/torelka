FROM debian:12

ENV container=docker
ENV CONTAINER_TIMEZONE=Etc/UTC
ENV DEBIAN_FRONTEND=noninteractive

RUN ln -snf /usr/share/zoneinfo/$CONTAINER_TIMEZONE /etc/localtime && \
    echo $CONTAINER_TIMEZONE > /etc/timezone

ARG PKG="tor obfs4proxy iproute2 curl procps"

RUN apt-get update --quiet --quiet && \
    apt-get install --quiet --quiet --yes \
    ${PKG} \
    && \
    apt-get --quiet --quiet clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY entrypoint.sh .
COPY healthcheck /usr/bin/healthcheck

RUN chmod +x /entrypoint.sh

ADD https://github.com/devil666face/t2s/releases/download/v10.30.11/t2s_linux_amd64.tar.gz .
ADD https://github.com/devil666face/gox/releases/download/v0.0.0/gox /usr/bin/gox

RUN tar -xf t2s_linux_amd64.tar.gz -C /usr/bin && \
    chmod +x /usr/bin/gox && \
    chmod +x /usr/bin/t2s && \
    chmod +x /usr/bin/healthcheck

EXPOSE 1080 53

HEALTHCHECK --interval=10s --timeout=10s --retries=3 --start-period=15s \
  CMD /usr/bin/healthcheck

ENTRYPOINT ["/entrypoint.sh"]
