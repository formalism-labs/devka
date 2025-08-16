FROM ubuntu:plucky

SHELL ["/bin/bash", "-l", "-c"]

WORKDIR /root

COPY --from=devka . /root/.devka
# RUN mv /root/.devka/classico /root/.devka/classiso.1
# COPY --from=classico . /root/.devka/classico

WORKDIR /root/.devka
RUN V=1 ./sbin/setup
RUN ./classico/bin/getbasics

WORKDIR /root

CMD ["/bin/bash", "-l"]
