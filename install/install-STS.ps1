. ".\utils.ps1"

function install-STS (
	[Parameter(Mandatory=$true)]
    [String] $destination
)
{
	Write-Host " ********************** Installing  Spring STS **********************"
	
	$source = "http://download.springsource.com/release/STS/3.8.3.RELEASE/dist/e4.6/spring-tool-suite-3.8.3.RELEASE-e4.6.2-win32-x86_64.zip"
	
	$STSTempDir = Join-Path "C:" "STSTemp"
	if (-Not (Test-Path -Path $STSTempDir -PathType Container)) {
		$d = mkdir $STSTempDir
	}
	
	$file = Join-Path $STSTempDir "spring-tool-suite-3.8.3.RELEASE-e4.6.2-win32-x86_64.zip"

	Write-Host "Downloading Spring STS ..."
	downloadFile $source $file
	Write-Host "Done."
	
	Write-Host "Extracting Spring STS ..."
	Expand-ZIPFile -File $file -Destination $STSTempDir
	Write-Host "Done."
	
	Move-Item "$STSTempDir\sts-bundle\sts-3.8.3.RELEASE" "$destination\sts-3.8.3.RELEASE"

	Write-Host "Setting up environmental variable ..."
	[Environment]::SetEnvironmentVariable("Path",[Environment]::GetEnvironmentVariable("Path", "User") + ";$destination\sts-3.8.3.RELEASE","User")
	Write-Host "Done."
	
	Write-Host "Removing TEMP directory ..."
	Remove-Item $STSTempDir -Recurse
	Write-Host "Done."
	
	Write-Host " ************ Spring STS has successfully been installed ************"
}