
# required for gnome-based systems
# to avoid premature configuration by gnome-shell
[[ $- != *i* ]] && return

if [[ -n $ZSH_VERSION || -n $FISH_VERSION ]]; then
	return
fi

export DEVKA="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [[ -n $CLASSICO && ! -d $CLASSICO ]]; then
	echo "devito: warning: CLASSICO is pointing to an invalid directory: $CLASSICO"
	unset CLASSICO
fi
if [[ -z $CLASSICO ]]; then
	export CLASSICO=$DEVKA/classico
fi

# export ENVENIDO_DEBUG=1

export ENVENIDO_ENVS="$DEVKA/envs"
export ENVENIDO_TITLE=Devka

if [[ $USER == root && -n $SUDO_USER ]]; then
	# echo "### devka: user is '$SUDO_USER'"
	export DEVKA_HOME="/home/$SUDO_USER"
else
	export DEVKA_HOME="$HOME"
fi

export ENVENIDO_USER_DEFS="$DEVKA_HOME/.devka-user/etc"

. $CLASSICO/envenido/envenido
