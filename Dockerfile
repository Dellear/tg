FROM alpine:3.7 AS build
RUN apk --no-cache add readline readline-dev libconfig libconfig-dev lua \
                       lua-dev luajit-dev luajit openssl openssl-dev \
                       build-base libevent libevent-dev libgcrypt-dev \
                       jansson jansson-dev git
RUN git clone --recursive https://github.com/vysheng/tg.git /tg 
RUN cd /tg && ./configure --disable-liblua --disable-openssl --prefix=/usr CFLAGS="$CFLAGS -w" && make


FROM alpine:3.7
MAINTAINER Dellear <dellear66@gmail.com>
COPY ./entrypoint.sh /entrypoint.sh
ENV TZ=Asia/Shanghai \
    LANG=zh_CN.UTF-8 \
    PS1="\u@\h:\w# "

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk update -f \
    && apk upgrade \
    && apk add --no-cache -f bash \
                            tzdata \
                            curl \
                            nano \
                            libevent \
                            jansson \
                            libconfig \
                            libgcrypt \
                            readline \
    && ln -sf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone \
    && chmod +x /entrypoint.sh
WORKDIR /config
COPY --from=build /tg/bin/telegram-cli /usr/bin/tg

ENTRYPOINT /entrypoint.sh
