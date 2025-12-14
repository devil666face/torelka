FROM scottyhardy/docker-remote-desktop:latest

ENV container=docker
ENV CONTAINER_TIMEZONE=Etc/UTC
ENV DEBIAN_FRONTEND=noninteractive

RUN ln -snf /usr/share/zoneinfo/$CONTAINER_TIMEZONE /etc/localtime && \
    echo $CONTAINER_TIMEZONE > /etc/timezone

ARG PKG="iproute2 curl procps openssh-server torbrowser-launcher"

RUN apt-get update && \
    apt-get install --yes \
    ${PKG} \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 3389 22

COPY entrypoint.sh .

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
