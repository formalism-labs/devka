
# irm https://raw.githubusercontent.com/formalism-labs/devka/refs/heads/main/sbin/setup-host.ps1 | iex

param (
	[string] $USER,
)

function install-devka {
	$home = "c:\msys64\home\${env:USERPROFILE}"
	$devka = "${home}\.devka"
	if (Test-Path -Path $devka) {
		Write-Output "Devka found in ${devka}: not installing"
		return
	}

	push-location

	try {	
		# setting up msys2
		irm https://raw.githubusercontent.com/formalism-labs/classico/refs/heads/master/sbin/bootstrap.ps1 | iex
		$classico = "${home}/.local/classico"
		& c:\msys64\usr\bin\bash.exe -l -c '$CLASSICO/bin/getgit'
		cd $home
		& c:\msys64\usr\bin\bash.exe -l -c 'git clone --recurse-submodule https://github.com/formalism-labs/devka.git .devka'
		& c:\msys64\usr\bin\bash.exe -l -c "GITHUB_USER=${USER} ~/.devka/sbin/setup-devka-user"
		& c:\msys64\usr\bin\bash.exe -l -c '~/.devka/sbin/setup'

		Write-Output "Done."
	} catch {
		pop-location
		Write-Error "Error installing Devka"
		return
	}
}

install-devka
