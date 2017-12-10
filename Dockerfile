FROM alpine:latest

MAINTAINER @silvinux [silvinux7@gmail.com]

ENV TUID 1000
ENV TGID 1000
ENV USERNAME admin
ENV PASSWORD password

RUN adduser -D -u $TUID -g $TGID tuser

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
USER tuser
CMD ["/start-transmission.sh"]
