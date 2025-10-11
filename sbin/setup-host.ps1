
# invoke using:
# iex "& { $(irm https://raw.githubusercontent.com/formalism-labs/devka/refs/heads/main/sbin/setup-host.ps1) } -PubKey 'ssh-rsa ...'"

param (
	[string] $PubKey
)

class RunspaceJob : System.IDisposable {
	[runspace] $Runspace
	[powershell] $PowerShell
	[System.IAsyncResult] $Handle
	[System.Management.Automation.PSDataCollection[psobject]] $Output
	
	RunspaceJob([ScriptBlock] $script, [object[]] $arguments) {
		$this.Runspace = [runspacefactory]::CreateRunspace()
		$this.Runspace.Open()
		
		# Create output collection
		$this.Output = New-Object 'System.Management.Automation.PSDataCollection[psobject]'
		
		# Create PowerShell instance
		$this.PowerShell = [powershell]::Create()
		$this.PowerShell.Runspace = $this.Runspace
		$this.PowerShell.AddScript($script) | Out-Null
		
		# Add arguments if provided
		if ($arguments) {
			foreach ($arg in $arguments) {
				$this.PowerShell.AddArgument($arg) | Out-Null
			}
		}
		
		# Start execution
		$this.Handle = $this.PowerShell.BeginInvoke($this.Output, $this.Output)
	}
	
	[bool] IsCompleted() {
		return $this.Handle.IsCompleted
	}
	
	[void] Stop() {
		if ($this.PowerShell) {
			$this.PowerShell.Stop()
		}
	}
	
	[object] EndInvoke() {
		if ($this.PowerShell) {
			return $this.PowerShell.EndInvoke($this.Handle)
		}
		return $null
	}
	
	Dispose() {
		$this.Stop()
		
		if ($this.PowerShell) {
			try {
				$this.EndInvoke()
			} catch {
				# Ignore errors during cleanup
			}
			$this.PowerShell.Dispose()
		}
		
		if ($this.Runspace) {
			$this.Runspace.Close()
			$this.Runspace.Dispose()
		}
	}
}

class SpinnerRunspace : RunspaceJob {
	SpinnerRunspace() : base({
			$Delay = 100  # ms per frame
			$Frames = @('|', '/', '-', '\')
			
			$i = 0
			try {
				while ($true) {
					$char = $frames[$i % $frames.Length]
					[Console]::Write("`r[$char]")
					Start-Sleep -Milliseconds $delay
					$i++
				}
			} catch {
				[Console]::Write("`r$([char]27)[K")
				# Silently exit when stopped
			}
		},
		@())
	{
		# Spinner-specific initialization
	}
}

function Show-Spinner {
	param (
		[Parameter(Mandatory = $true)]
		[ScriptBlock] $Script
	)

	$spinner = [SpinnerRunspace]::new()
	try {
		$result = & $Script
		
		[Console]::Write("`r$([char]27)[K")
		Write-Host "✔  Done" -ForegroundColor Green
		return $result
		
	} catch {
		[Console]::Write("`r$([char]27)[K")
		Write-Host "✖  Failed:" -ForegroundColor Red
		Write-Host $_.Exception.Message -ForegroundColor Red
		throw
	} finally {
		$spinner.Dispose()
		# Small delay to ensure spinner stops cleanly
		Start-Sleep -Milliseconds 50
	}
}

function runn_url {
	param(
		[Parameter(Mandatory)]
		[Uri] $Url
	)

	$log = "$env:TEMP\runn.log"
	Remove-Item $log -Force -ErrorAction SilentlyContinue

	$progress = $ProgressPreference
	try {
		$ProgressPreference = 'SilentlyContinue';
			(irm $Url) | iex *> $log  # $null 
			if ($LASTEXITCODE -ne 0) {
			throw "Failed executing script from $Url"
		}
	} catch {
	        Get-Content $log
			throw
	} finally {
		$ProgressPreference = $progress
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
		Write-Output "Downloading MSYS2 ..."
		Show-Spinner {
			runn_url https://raw.githubusercontent.com/formalism-labs/devka/refs/heads/main/sbin/setup-msys2.ps1
		}

		# install git
		Write-Output "Installing Git ..."
		Show-Spinner {
			bash('pacman --noconfirm --needed -S git &> /dev/null')
		}

		cd $_home
		bash('git clone -q --recurse-submodule https://github.com/formalism-labs/devka.git .devka')

		# clone devka-user without user customization because this typically requires a private key
		bash('git clone -q https://github.com/formalism-labs/devka-user.git .devka-user')

		# set up devka (and classico)
		bash('~/.devka/sbin/setup')

		bash('~/.devka/classico/win/msys2/setup-winterm')

		# set up ssh
		Write-Output "Setting up SSH ..."
		bash("PUBKEY='${PubKey}' ~/.devka/classico/bin/runn ~/.devka/classico/win/msys2/setup-sshd")

		Write-Output "Done."
	} catch {
		Write-Error "Error installing Devka:"
		Write-Error $_.Exception.Message
	} finally {
		pop-location
	}
}

install-devka
