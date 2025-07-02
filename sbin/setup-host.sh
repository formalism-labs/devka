#!/bin/bash

# curl -fsSL https://raw.githubusercontent.com/formalism-labs/devka/refs/heads/main/sbin/setup-host.sh | GITHUB_USER=raffapen bash

if ! command -v $1 &> /dev/null; then
	>&2 echo "Please install git and retry."
	exit 1
fi

[[ -z $GITHUB_USER && -n $DEVKA_GITHUB_USER ]] && GITHUB_USER="$DEVKA_GITHUB_USER"

runn() {
	(( NOP == 1 || V >= 1 )) && { >&2 echo "$@"; }
	[[ $NOP == 1 ]] && { return; }
	if (( V < 2 )); then
		local log="$(mktemp devito-setup.XXXXXX)"
		{ eval "$@" > "$log" 2>&1 ; E=$?; } || true
		[[ $E != 0 && $LOG != 0 ]] && cat "$log"
		rm -f "$log"
		return $E
	else
		eval "$@"
	fi
}

$SUDO true

cd $HOME
if [[ ! -d .devka ]]; then
	runn git clone --recurse-submodule https://github.com/formalism-labs/devka.git .devka
else
	runn git -C .devka pull --recurse-submodule
fi
if [[ ! -d .devka-user ]]; then
	runn git clone https://github.com/formalism-labs/devka-user.git .devka-user
	if [[ -n GITHUB_USER ]]; then
		local dir="$PWD"
		cd .devka-user
		runn git remote add $GITHUB_USER git@github.com:${GITHUB_USER}/devka-user.git
		runn git fetch ${GITHUB_USER}
		runn git branch --set-upstream-to=${GITHUB_USER}/main main
		cd $dir
	fi
fi
runn git -C .devka-user pull

./.devka/sbin/setup
bash -l
