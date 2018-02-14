. ".\utils.ps1"

function install-JDK (
	[Parameter(Mandatory=$true)]
    [String] $destination
)
{
	$JDK_VER="8u111"
	$JDK_FULL_VER="8u111-b14"
	$JDK_PATH="1.8.0_u111"

	Write-Host " ********************** Installing  JDK **********************"
	
	$source = "http://download.oracle.com/otn-pub/java/jdk/$JDK_FULL_VER/jdk-$JDK_VER-windows-x64.exe"
	
	$JDKTempDir = Join-Path $env:TEMP "JDKTemp"
	if (-Not (Test-Path -Path $JDKTempDir -PathType Container)) {
		$d = mkdir $JDKTempDir
	}
	
	$file = Join-Path $JDKTempDir "jdk-8u111-windows-x64.exe"

	Write-Host "Downloading JDK version $JDK_VER ..."
	downloadFile $source $file
	Write-Host "Done."
	
	try {
		Write-Host 'Installing JDK-x64'
		$proc = Start-Process -FilePath "$file" -ArgumentList "/s REBOOT=ReallySuppress INSTALLDIR=$destination" -Wait -PassThru
		$proc.waitForExit()
		Write-Host 'Installation Done.'
	} catch [exception] {
		write-host '$_ is' $_
		write-host '$_.GetType().FullName is' $_.GetType().FullName
		write-host '$_.Exception is' $_.Exception
		write-host '$_.Exception.GetType().FullName is' $_.Exception.GetType().FullName
		write-host '$_.Exception.Message is' $_.Exception.Message
	}
	
	Write-Host "Setting up environmental variable ..."
	[System.Environment]::SetEnvironmentVariable("JAVA_HOME", "$destination\jdk$JDK_PATH", "User")
	[System.Environment]::SetEnvironmentVariable("PATH", $Env:Path + ";$destination\jdk$JDK_PATH\bin", "User")
	Write-Host "Done."
	
	
	Write-Host "Removing TEMP directory ..."
	Remove-Item $JDKTempDir -Recurse
	Write-Host "Done."
	
	Write-Host " ************ JDK has successfully been installed ************"
}