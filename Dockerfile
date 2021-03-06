FROM alpine:3.8

RUN apk add rsync bash --no-cache

RUN mkdir -p /log && chmod 777 /log
VOLUME /log

COPY rsyncer.sh /
ENTRYPOINT ["/rsyncer.sh"]
