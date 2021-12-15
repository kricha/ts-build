FROM alpine

RUN echo "$TARGETPLATFORM | $TARGETOS | $TARGETARCH | $TARGETVARIANT | $BUILDPLATFORM | $BUILDOS | $BUILDARCH | $BUILDVARIANT"

RUN apk add --update --no-cache ffmpeg \
&& wget -O /usr/bin/torrserver https://github.com/YouROK/TorrServer/releases/download/MatriX.110/TorrServer-linux-arm64 \
&& chmod +x /usr/bin/torrserver \
&& mkdir -p /opt/db

EXPOSE 8090:8090

CMD ["torrserver", "--path", "/opt/db"]

