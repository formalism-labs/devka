
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

function With-Env {
    param(
        [Parameter(Mandatory, Position = 0)]
        [hashtable] $vars,
        [Parameter(Mandatory, Position = 1)]
        [ScriptBlock] $script
    )

    # Save values
    $old = @{}
    foreach ($k in $vars.Keys) {
        $old[$k] = (Get-Item "Env:$k" -ErrorAction SilentlyContinue).Value
        Set-Item "Env:$k" $vars[$k]
    }

    try {
		& $script
		$exitCode = $LASTEXITCODE
        if ($exitCode -ne 0) {
            throw "Command failed with exit code $exitCode"
        }
    } finally {
        # Restore values
        foreach ($k in $vars.Keys) {
            if ($null -eq $old[$k]) {
                Remove-Item "Env:$k" -ErrorAction SilentlyContinue
            } else {
                Set-Item "Env:$k" $old[$k]
            }
        }
    }
}

function bash([string] $cmd) {
    $bash = "C:\msys64\usr\bin\bash.exe"
	with-env @{ MSYSTEM = "MINGW64"; MSYS = $env:MSYS + ",disable_pcon" } {
		& $bash -l -c "$cmd"
	}
    if ($LASTEXITCODE -ne 0) {
        throw "'$cmd' failed with exit code $LASTEXITCODE"
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

		# install git
		bash('pacman --noconfirm --needed -S git')

		cd $_home
		bash('git clone --recurse-submodule https://github.com/formalism-labs/devka.git .devka')

		# clone devka-user without user customization because this typically requires a private key
		bash('git clone https://github.com/formalism-labs/devka-user.git .devka-user')

		# set up devka (and classico)
		bash('~/.devka/sbin/setup')

		bash('~/.devka/classico/win/msys2/setup-winterm')

		# set up ssh
		bash("PUBKEY='${PubKey}' ~/.devka/classico/win/msys2/setup-sshd")

		Write-Output "Done."
	} catch {
		Write-Error "Error installing Devka:"
		Write-Error $_.Exception.Message
	} finally {
		pop-location
    }
}

install-devka
