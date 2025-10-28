ARG DOS
FROM ${DOS}

SHELL ["/bin/bash", "-l", "-c"]

WORKDIR /root
RUN ls -A1 > .dirs

USER ${USER_NAME}
WORKDIR /home/${USER_NAME}

COPY --from=devka . /root/.devka
COPY --from=devka_user . /root/.devka-user

WORKDIR /root/.devka
RUN V=1 ./sbin/setup
RUN V=1 ./devbox/setup

WORKDIR /root

CMD ["/bin/bash", "-l"]
