ARG DECONZ_VERSION=2.11.05

FROM debian:10-slim as compile-plugin

ENV DEBIAN_FRONTEND="noninteractive"
ENV TERM="xterm"

RUN apt-get update && apt-get install -y git qt5-default libqt5websockets5-dev libqt5serialport5-dev sqlite3 libcap2-bin lsof curl libsqlite3-dev libssl-dev g++ make

ARG DECONZ_VERSION

# Install deconz & deconz-dev
ADD http://deconz.dresden-elektronik.de/ubuntu/beta/deconz-$DECONZ_VERSION-qt5.deb /tmp/deconz.deb
ADD http://deconz.dresden-elektronik.de/ubuntu/beta/deconz-dev-$DECONZ_VERSION.deb /tmp/deconz-dev.deb

RUN dpkg -i /tmp/deconz.deb
RUN dpkg -i /tmp/deconz-dev.deb

# Declare here to cache the previous steps
ARG PLUGIN_REPOSITORY=https://github.com/dresden-elektronik/deconz-rest-plugin.git
ARG PLUGIN_GIT_COMMIT=8c87fbb012b6c71543a04b3d80982e66e62ed19d

# Get code from repository and compile
RUN git clone $PLUGIN_REPOSITORY && cd deconz-rest-plugin && git checkout $PLUGIN_GIT_COMMIT && qmake && make -j2

FROM marthoc/deconz:${DECONZ_VERSION} AS final-image

COPY --from=compile-plugin /libde_rest_plugin.so /usr/share/deCONZ/plugins/libde_rest_plugin.so
