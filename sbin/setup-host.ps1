
# invoke using:
# iex "& { $(irm https://raw.githubusercontent.com/formalism-labs/devka/refs/heads/main/sbin/setup-host.ps1) } -PubKey 'ssh-rsa ...'"

param (
	[string] $PubKey
)

function install-devka {
	$_home = "c:\msys64\home\${env:USERNAME}"
	$devka = "${_home}\.devka"
	if (Test-Path -Path $devka) {
		Write-Output "Devka found in ${devka}: not installing"
		return
	}

	push-location

	try {
		# setting up msys2
		irm https://raw.githubusercontent.com/formalism-labs/devka/refs/heads/main/sbin/setup-msys2.ps1 | iex
		$bash = "c:\msys64\usr\bin\bash.exe"

		# install git
		& $bash -l -c 'pacman --noconfirm --needed -S git'

		cd $_home
		& $bash -l -c 'git clone --recurse-submodule https://github.com/formalism-labs/devka.git .devka'

		# clone devka-user without user customization because this typically requires a private key
		& $bash -l -c 'git clone https://github.com/formalism-labs/devka-user.git .devka'

		# set up devka (and classico)
		& $bash -l -c '~/.devka/sbin/setup'
		
		# set up ssh
		& $bash -l -c "PUBKEY='${PubKey}' ~/.devka/classico/win/msys2/setup-sshd"

		Write-Output "Done."
	} catch {
		Write-Error "Error installing Devka:"
		Write-Error $_.Exception.Message
	} finally {
		pop-location
    }
}

install-devka
