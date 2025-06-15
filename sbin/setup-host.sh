#!/bin/bash

# curl -fsSL https://raw.githubusercontent.com/formalism-labs/devka/refs/heads/main/sbin/setup-host.sh | GITHUB_USER=raffapen bash

if ! command -v $1 &> /dev/null; then
	>&2 echo "Please install git and retry."
	exit 1
fi

[[ -z $GITHUB_USER && -n $DEVKA_GITHUB_USER ]] && GITHUB_USER="$DEVKA_GITHUB_USER"

cd $HOME
if [[ ! -d .devka ]]; then
	git clone --recurse-submodule https://github.com/formalism-labs/devka.git .devka
else
	git -C .devka pull --recurse-submodule
fi
if [[ ! -d .devka-user ]]; then
	git clone https://github.com/formalism-labs/devka-user.git .devka-user
	if [[ -n GITHUB_USER ]]; then
		cd .devka-user
		git remote add $GITHUB_USER git@github.com:${GITHUB_USER}/devka-user.git
		git fetch ${GITHUB_USER}
		git branch --set-upstream-to=${GITHUB_USER}/main main
		cd -
	fi
fi
git -C .devka-user pull

./.devka/sbin/setup
