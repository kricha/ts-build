FROM alpine

ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT
ARG TS_TAG

ENV TS_CONF_PATH="/opt/ts/config"
ENV TS_LOG_PATH="/opt/ts/log"
ENV TS_PORT=8090

RUN apk add --update --no-cache ffmpeg \
&& wget -O /usr/bin/torrserver https://github.com/YouROK/TorrServer/releases/download/${TS_TAG}/TorrServer-${TARGETOS}-${TARGETARCH} \
&& chmod +x /usr/bin/torrserver \
&& mkdir -p $TS_CONF_PATH && mkdir $TS_LOG_PATH

CMD torrserver -d $TS_CONF_PATH -l $TS_LOG_PATH -p $TS_PORT
