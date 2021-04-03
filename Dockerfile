FROM ubuntu:latest AS build
RUN apt update && DEBIAN_FRONTEND=noninteractive apt -y install libreadline-dev libconfig-dev libssl-dev lua5.2 liblua5.2-dev libevent-dev libjansson-dev libpython2-dev make zlib1g-dev libgcrypt20-dev git
RUN git clone --recursive https://github.com/vysheng/tg.git /tg 
RUN cd /tg && ./configure --disable-openssl --prefix=/usr CFLAGS="$CFLAGS -w" && CGO_ENABLED=0 make


FROM ubuntu:latest
COPY ./entrypoint.sh /entrypoint.sh
ENV TZ=Asia/Shanghai \
    DEBIAN_FRONTEND=noninteractive
RUN apt update \
    && apt -y install cron \
                nano \
                libevent-dev \
                libjansson-dev \
                libconfig-dev \
                libreadline-dev \
                liblua5.2-dev \
    && ln -sf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/log/* \
    && chmod +x /entrypoint.sh
WORKDIR /config
COPY --from=build /tg/bin/telegram-cli /usr/bin/tg

ENTRYPOINT /entrypoint.sh
