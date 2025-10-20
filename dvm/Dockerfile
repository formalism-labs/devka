ARG DOS
FROM ${DOS}

SHELL ["/bin/bash", "-l", "-c"]

WORKDIR /root

COPY --from=devka . /root/.devka
COPY --from=devka_user . /root/.devka-user

WORKDIR /root/.devka
RUN V=1 ./sbin/setup
RUN ./classico/bin/getbasics

WORKDIR /root

CMD ["/bin/bash", "-l"]
