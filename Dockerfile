ARG PLUGIN_REPOSITORY=https://github.com/dresden-elektronik/deconz-rest-plugin.git
ARG PLUGIN_GIT_COMMIT=master

FROM debian:10-slim as compile-plugin

ENV DEBIAN_FRONTEND="noninteractive"
ENV TERM="xterm"

RUN apt-get update && apt-get install -y git qt5-default libqt5websockets5-dev libqt5serialport5-dev qtdeclarative5-dev sqlite3 libcap2-bin lsof curl libsqlite3-dev libssl-dev g++ make gnupg2

RUN curl -L http://phoscon.de/apt/deconz.pub.key | apt-key add -
RUN sh -c "echo 'deb [arch=amd64] http://phoscon.de/apt/deconz \
            buster-beta main' > \
            /etc/apt/sources.list.d/deconz.list"
RUN apt-get update && apt-get install -y deconz deconz-dev

ARG PLUGIN_REPOSITORY
ARG PLUGIN_GIT_COMMIT

# Get code from repository and compile
RUN git clone $PLUGIN_REPOSITORY && cd deconz-rest-plugin && git checkout $PLUGIN_GIT_COMMIT && qmake && make -j2

FROM deconzcommunity/deconz:latest AS final-image

COPY --from=compile-plugin /libde_rest_plugin.so /usr/share/deCONZ/plugins/libde_rest_plugin.so
