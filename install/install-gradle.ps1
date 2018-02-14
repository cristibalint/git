. ".\utils.ps1"

function install-Gradle (
	[Parameter(Mandatory=$true)]
    [String] $destination
)
{
	Write-Host " ************************ Installing Gradle *************************"
	
	$source = "https://services.gradle.org/distributions/gradle-3.3-bin.zip"
	
	$GradleTempDir = Join-Path $env:TEMP "GradleTemp"
	if (-Not (Test-Path -Path $GradleTempDir -PathType Container)) {
		$d = mkdir $GradleTempDir
	}
	
	$file = Join-Path $GradleTempDir "gradle-3.3-bin.zip"

	Write-Host "Downloading Gradle ..."
	downloadFile $source $file
	Write-Host "Done."
	
	Write-Host "Extracting Gradle ..."
	Expand-ZIPFile -File $file -Destination $destination
	Write-Host "Done."
	
	Write-Host "Setting up environmental variable ..."
	[Environment]::SetEnvironmentVariable("Path",[Environment]::GetEnvironmentVariable("Path", "User") + ";$destination\gradle-3.3\bin","User")
	Write-Host "Done."
	
	Write-Host "Removing TEMP directory ..."
	Remove-Item $GradleTempDir -Recurse
	Write-Host "Done."
	
	Write-Host " ************** Gradle has successfully been installed **************"
}