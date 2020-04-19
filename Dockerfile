FROM alpine:latest

MAINTAINER @silvinux [silvinux7@gmail.com]

ARG TUID=1000
ARG TGID=1000
ARG USERNAME=silvinux
ARG PASSWORD=toor

ENV TUID=${TUID} 
ENV TGID=${TGID} 
ENV USERNAME=${USERNAME}
ENV PASSWORD=${PASSWORD}

RUN adduser -D -u $TUID -g $TGID $USERNAME

RUN apk add --update \
    transmission-daemon \
    && rm -rf /var/cache/apk/*

RUN mkdir -p /transmission/{downloads,incomplete} && \
    mkdir -p /etc/transmission-daemon &&\
    chown -R $TUID:$TGID /transmission && \
    chown -R $TUID:$TGID /etc/transmission-daemon 

ADD files/etc/transmission-daemon/ /etc/transmission-daemon/
ADD files/start-transmission.sh /start-transmission.sh

VOLUME ["/transmission/downloads"]
VOLUME ["/transmission/incomplete"]
VOLUME ["/transmission/TV_Shows"]

EXPOSE 9091 51413/tcp 51413/udp

RUN chmod +x /start-transmission.sh
USER $USERNAME
CMD ["/start-transmission.sh"]
