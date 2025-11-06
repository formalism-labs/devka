ARG DOS
FROM ${DOS}

SHELL ["/bin/bash", "-l", "-c"]

WORKDIR /root

COPY --from=devka ./devbox/setup-user /tmp/setup-user
RUN chmod +x /tmp/setup-user; /tmp/setup-user; rm /tmp/setup-user

USER user
WORKDIR /home/.user

COPY --chown=user:user --from=devka      . /home/.user/.devka
COPY --chown=user:user --from=devka_user . /home/.user/.devka-user

WORKDIR /home/.user/.devka
RUN V=1 ./sbin/setup
RUN V=1 ./devbox/setup

WORKDIR /home/.user

CMD ["/bin/bash", "-l"]
