FROM kalilinux/kali-last-release:latest

ENV container=docker
ENV CONTAINER_TIMEZONE=Etc/UTC
ENV DEBIAN_FRONTEND=noninteractive
ENV SYSTEMD_LOG_LEVEL=debug

RUN ln -snf /usr/share/zoneinfo/$CONTAINER_TIMEZONE /etc/localtime && \
    echo $CONTAINER_TIMEZONE > /etc/timezone

ARG PKG="systemd systemd-sysv iproute2 curl procps \
xrdp xorgxrdp xserver-xorg-core x11-xkb-utils openssh-server dbus-x11 sudo plasma-desktop konsole libreoffice curl gnupg ca-certificates bzip2 xz-utils desktop-file-utils python3 python3-venv python3-pip p7zip-full cron zip dnsutils dolphin kio-extras \
firefox-esr"

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

VOLUME [ "/sys/fs/cgroup" ]

EXPOSE 3389

COPY entrypoint.service /etc/systemd/system/entrypoint.service
COPY entrypoint.sh .

RUN chmod +x /entrypoint.sh && \
    ln -sf /etc/systemd/system/entrypoint.service /etc/systemd/system/multi-user.target.wants/entrypoint.service

ENTRYPOINT ["/lib/systemd/systemd"]
CMD ["/lib/systemd/systemd"]
