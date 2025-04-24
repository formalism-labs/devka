FROM ubuntu:noble

ARG DEVKA_USER_REPO=formalism-labs/devka-user

SHELL ["/bin/bash", "-l", "-c"]

WORKDIR /build

RUN apt-get update -qq
RUN apt-get install -y git

WORKDIR /root
RUN git clone --recurse-submodule https://github.com/formalism-labs/devka.git .devka
RUN git clone https://github.com/formalism-labs/devka-user.git .devka-user

WORKDIR /root/.devka
RUN ./sbin/setup

# for debugging
RUN mixenv classico ;\
	getbashdb ;\
	getpudb ;\
	runn apt-get install -y mc vim htop tmux

WORKDIR /root

CMD ["/bin/bash", "-l"]
