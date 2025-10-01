
# invoke using:
# iex "& { $(irm https://raw.githubusercontent.com/formalism-labs/devka/refs/heads/main/sbin/setup-host.ps1) } -PubKey 'ssh-rsa ...'"

param (
	[string] $PubKey
)

function runn_url {
    param(
        [Parameter(Mandatory)]
        [Uri] $Url
    )

	$log = "$env:TEMP\runn.log"
    Remove-Item $log -Force -ErrorAction SilentlyContinue

    try {
        (irm $Url) | iex *> $log
        if ($LASTEXITCODE -ne 0) {
            throw "Failed executing script from $Url"
        }
    }
    catch {
        Get-Content $log
        throw
    }
}

function install-devka {
	$_home = "c:\msys64\home\${env:USERNAME}"
	$devka = "${_home}\.devka"
	if (Test-Path -Path $devka) {
		Write-Output "Devka found in ${devka}: not installing"
		return
	}

	push-location

	try {
		# set up msys2
		runn_url https://raw.githubusercontent.com/formalism-labs/devka/refs/heads/main/sbin/setup-msys2.ps1
		$bash = "c:\msys64\usr\bin\bash.exe"

		# install git
		& $bash -l -c 'pacman --noconfirm --needed -S git'

		cd $_home
		& $bash -l -c 'git clone --recurse-submodule https://github.com/formalism-labs/devka.git .devka'

		# clone devka-user without user customization because this typically requires a private key
		& $bash -l -c 'git clone https://github.com/formalism-labs/devka-user.git .devka-user'

		# set up devka (and classico)
		& $bash -l -c '~/.devka/sbin/setup'

		& $bash -l -c "~/.devka/classico/win/msys2/setup-winterm"

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
