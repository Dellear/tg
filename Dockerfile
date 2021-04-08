FROM ubuntu:latest AS build
RUN apt update && DEBIAN_FRONTEND=noninteractive apt -y install libreadline-dev libconfig-dev libssl-dev lua5.2 liblua5.2-dev libevent-dev libjansson-dev libpython2-dev make zlib1g-dev libgcrypt20-dev git
RUN git clone --recursive https://github.com/vysheng/tg.git /tg 
RUN cd /tg && ./configure --disable-liblua --disable-openssl --prefix=/usr CFLAGS="$CFLAGS -w" && make


FROM ubuntu:latest
COPY ./entrypoint.sh /entrypoint.sh
ENV TZ=Asia/Shanghai \
    DEBIAN_FRONTEND=noninteractive
RUN apt update \
    && apt -y install cron \
                curl \
                nano \
                libevent-dev \
                libjansson-dev \
                libconfig-dev \
                libreadline-dev \
    && ln -sf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone \
    && rm -rf /var/lib/apt/lists/* /var/cache/* /var/log/* \
    && chmod +x /entrypoint.sh
WORKDIR /config
COPY --from=build /tg/bin/telegram-cli /usr/bin/tg

ENTRYPOINT /entrypoint.sh
