#!/usr/bin/env bash

set -e

if [[ $BASH_VERSINFO == 3 ]]; then
	perror "Bash version is too old - please install Bash 5 and retry."
	exit 1
fi

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

ln -s . $HOME/.devito
cd $HOME

runn git clone https://github.com/formalism-labs/devka-user.git .devka-user

./.devka/sbin/setup
