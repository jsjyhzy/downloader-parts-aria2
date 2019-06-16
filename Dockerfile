FROM ubuntu:18.04 as builder

ENV ARIA2_TAG=release-1.34.0

RUN apt-get update &&\
    apt-get install git clang libssh2-1-dev libc-ares-dev libxml2-dev zlib1g-dev libsqlite3-dev pkg-config libssl-dev libexpat1-dev libxml2-dev liblzma-dev libcppunit-dev autoconf automake autotools-dev autopoint libtool -y &&\
    update-ca-certificates &&\
    git clone https://github.com/aria2/aria2.git &&\
    cd aria2 &&\
    git checkout $ARIA2_TAG &&\
    autoreconf -i &&\
    ./configure ARIA2_STATIC=yes --with-ca-bundle='/etc/ssl/certs/ca-certificates.crt' &&\
    make &&\
    make check

FROM ubuntu:18.04

WORKDIR /aria2

VOLUME [ "/data" , "/config"]

COPY --from=builder /aria2/src/aria2c .

COPY template/config.template .

COPY startup.sh .

EXPOSE 6800

RUN apt-get update &&\
    apt-get install gettext-base ca-certificates -y

ENTRYPOINT [ "bash", "startup.sh" ]