FROM ubuntu:plucky

SHELL ["/bin/bash", "-l", "-c"]

WORKDIR /root

COPY --from=devka . /root/.devka

WORKDIR /root/.devka
RUN V=1 ./sbin/setup
RUN ./classico/bin/getbasics

WORKDIR /root

CMD ["/bin/bash", "-l"]
