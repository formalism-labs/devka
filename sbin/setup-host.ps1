
# irm https://raw.githubusercontent.com/formalism-labs/devka/refs/heads/main/sbin/setup-host.ps1 | iex

param (
	[string] $USER,
	[string] $PUBKEY
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
		irm https://raw.githubusercontent.com/formalism-labs/classico/refs/heads/master/sbin/bootstrap.ps1 | iex
		$bash = "c:\msys64\usr\bin\bash.exe"
		& $bash -l -c '$CLASSICO/bin/getgit'
		cd $_home
		& $bash -l -c 'git clone --recurse-submodule https://github.com/formalism-labs/devka.git .devka'
		& $bash -l -c "GITHUB_USER=${USER} ~/.devka/sbin/setup-devka-user"
		& $bash -l -c '~/.devka/sbin/setup'
		& $bash -l -c "PUBKEY=${PUBKEY} ~/.devka/classico/win/msys2/setup-sshd"

		Write-Output "Done."
	} catch {
		pop-location
		Write-Error "Error installing Devka"
		return
	}
}

install-devka
