#!/bin/bash

# curl -fsSL https://raw.githubusercontent.com/formalism-labs/devka/refs/heads/main/sbin/setup-host.sh | bash

if ! command -v $1 &> /dev/null; then
	>&2 echo "Please install git and retry."
	exit 1
fi

DEVKA_USER_REPO=${DEVKA_USER_REPO:-formalism-labs/devka-user}

cd $HOME
git clone --recurse-submodule https://github.com/formalism-labs/devka.git .devka
git clone https://github.com/${DEVKA_USER_REPO}.git .devka-user

./.devka/sbin/setup
