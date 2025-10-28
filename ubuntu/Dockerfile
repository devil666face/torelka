FROM scottyhardy/docker-remote-desktop:latest

ENV container=docker
ENV CONTAINER_TIMEZONE=Etc/UTC
ENV DEBIAN_FRONTEND=noninteractive
ENV SYSTEMD_LOG_LEVEL=debug

RUN ln -snf /usr/share/zoneinfo/$CONTAINER_TIMEZONE /etc/localtime && \
    echo $CONTAINER_TIMEZONE > /etc/timezone

ARG PKG="iproute2 curl procps openssh-server"

RUN apt-get update && \
    apt-get install --yes \
    ${PKG} \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    rm -rf /lib/systemd/system/multi-user.target.wants/* && \
    rm -rf /etc/systemd/system/*.wants/* && \
    rm -rf /lib/systemd/system/local-fs.target.wants/* && \
    rm -rf /lib/systemd/system/sockets.target.wants/*udev* && \
    rm -rf /lib/systemd/system/sockets.target.wants/*initctl* && \
    rm -rf /lib/systemd/system/sysinit.target.wants/systemd-tmpfiles-setup* && \
    rm -rf /lib/systemd/system/systemd-update-utmp*

EXPOSE 3389 22

COPY entrypoint.sh .

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
