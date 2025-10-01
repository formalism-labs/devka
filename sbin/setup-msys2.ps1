
function Get-IanaTimeZone() {
    param(
        [string]$WindowsTimeZoneId = (Get-TimeZone).Id
    )
	
    # Location of the mapping file
    $mapFile = "$env:TEMP\windowsZones.xml"

    # Download CLDR mapping if not cached
    if (-not (Test-Path $mapFile)) {
		$progress = $ProgressPreference
		$ProgressPreference = 'SilentlyContinue'
        Invoke-WebRequest `
			-Uri "https://raw.githubusercontent.com/unicode-org/cldr/master/common/supplemental/windowsZones.xml" `
            -OutFile $mapFile
		$ProgressPreference = $progress
    }

    [xml]$xml = Get-Content $mapFile

    # Look up IANA tz with "territory=001" (the canonical mapping)
    $iana = $xml.supplementalData.windowsZones.mapTimezones.mapZone |
        Where-Object { $_.other -eq $WindowsTimeZoneId -and $_.territory -eq "001" } |
        Select-Object -ExpandProperty type -ErrorAction Ignore

    if (-not $iana) {
        Write-Error "No IANA mapping found for Windows timezone '$WindowsTimeZoneId'"
    }

    return $iana
}

$f = ""
try {
	if (Test-Path "c:\msys64" -PathType Container) {
		Write-Error "msys2 is installed."
		return 1
	}

	push-location

	$f = "$env:temp\msys2-sfx.exe"
	irm -outfile $f https://github.com/msys2/msys2-installer/releases/download/nightly-x86_64/msys2-base-x86_64-latest.sfx.exe
	cd c:\
	& $f

	$env:MSYS = "winsymlinks:native"
	setx MSYS "winsymlinks:native" /m

	$env:HOME = "/home/" + $env:USERNAME
	$env:TZ = Get-IanaTimeZone

	& c:\msys64\usr\bin\bash.exe -l -c true
} catch {
	Write-Error "Error during msys2 installation: $($_.Exception.Message)"
	throw [System.Exception]::new("Msys2 installation failed", $_.Exception)
} finally {
	pop-location
	Remove-Item $f -ErrorAction SilentlyContinue
}
