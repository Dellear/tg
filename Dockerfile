FROM centos:7
COPY ./entrypoint.sh /entrypoint.sh
ADD ./tg.tar.gz /tg
ENV TZ=Asia/Shanghai
RUN yum update -y nss curl libcurl \
    && yum -y install lua-devel \
                      openssl-devel \
                      libconfig-devel \
                      readline-devel \
                      libevent-devel \
                      jansson-devel \
                      python-devel \
                      gcc \
                      make \
                      crontabs \
    && cd /tg \
    && chmod +x ./configure \
    && ./configure \
    && make \
    && ln -snf /tg/bin/telegram-cli /usr/bin/tg \
    && sed -i -e '/pam_loginuid.so/s/^/#/' /etc/pam.d/crond \
    && yum -y remove lua-devel \
                      openssl-devel \
                      libconfig-devel \
                      readline-devel \
                      libevent-devel \
                      jansson-devel \
                      python-devel \
                      gcc \
                      make \
    && yum clean all \
    && rm -rf /var/cache/ \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && chmod +x /entrypoint.sh
WORKDIR /tg
ENTRYPOINT /entrypoint.sh