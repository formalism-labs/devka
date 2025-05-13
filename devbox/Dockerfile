FROM ubuntu:noble

SHELL ["/bin/bash", "-l", "-c"]

WORKDIR /root

COPY --from=devka . /root/.devka

WORKDIR /root/.devka/classico
RUN V=1 ./sbin/setup

WORKDIR /root/.devka
RUN V=1 ./devbox/setup

WORKDIR /root

CMD ["/bin/bash", "-l"]
