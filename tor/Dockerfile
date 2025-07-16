FROM debian:12

ENV container=docker
ENV CONTAINER_TIMEZONE=Etc/UTC
ENV DEBIAN_FRONTEND=noninteractive
ENV SYSTEMD_LOG_LEVEL=debug

RUN ln -snf /usr/share/zoneinfo/$CONTAINER_TIMEZONE /etc/localtime && \
    echo $CONTAINER_TIMEZONE > /etc/timezone

ARG PKG="systemd systemd-sysv tor obfs4proxy iproute2 curl procps"

RUN apt-get update --quiet --quiet && \
    apt-get install --quiet --quiet --yes \
    ${PKG} \
    && \
    apt-get --quiet --quiet clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    rm -rf /lib/systemd/system/multi-user.target.wants/* && \
    rm -rf /etc/systemd/system/*.wants/* && \
    rm -rf /lib/systemd/system/local-fs.target.wants/* && \
    rm -rf /lib/systemd/system/sockets.target.wants/*udev* && \
    rm -rf /lib/systemd/system/sockets.target.wants/*initctl* && \
    rm -rf /lib/systemd/system/sysinit.target.wants/systemd-tmpfiles-setup* && \
    rm -rf /lib/systemd/system/systemd-update-utmp*

VOLUME [ "/sys/fs/cgroup" ]

COPY entrypoint.service /etc/systemd/system/entrypoint.service
COPY entrypoint.sh .
COPY healthcheck /usr/bin/healthcheck

RUN chmod +x /entrypoint.sh && \
    ln -sf /etc/systemd/system/entrypoint.service /etc/systemd/system/multi-user.target.wants/entrypoint.service

ADD https://github.com/devil666face/t2s/releases/download/v07.16.11/t2s_linux_amd64.tar.gz .
ADD https://github.com/devil666face/gox/releases/download/v0.0.0/gox /usr/bin/gox

RUN tar -xf t2s_linux_amd64.tar.gz -C /usr/bin && \
    chmod +x /usr/bin/gox && \
    chmod +x /usr/bin/t2s && \
    chmod +x /usr/bin/healthcheck

EXPOSE 1080 53

HEALTHCHECK --interval=5s --timeout=5s --retries=3 --start-period=5s \
  CMD /usr/bin/healthcheck

ENTRYPOINT ["/lib/systemd/systemd"]
CMD ["/lib/systemd/systemd"]
