#!/bin/bash

# curl -fsSL https://raw.githubusercontent.com/formalism-labs/devka/refs/heads/main/sbin/setup-host.sh | bash

if ! command -v $1 &> /dev/null; then
	>&2 echo "Please install git and retry."
	exit 1
fi

DEVKA_USER_REPO=${DEVKA_USER_REPO:-formalism-labs/devka-user}

cd $HOME
if [[ ! -d .devka ]]; then
	git clone --recurse-submodule https://github.com/formalism-labs/devka.git .devka
else
	git pull
fi
if [[ ! -d .devka-user ]]; then
	git clone https://github.com/${DEVKA_USER_REPO}.git .devka-user
else
	git pull
fi

./.devka/sbin/setup
