function downloadFile (
	[Parameter(Mandatory=$true)]
    [String] $source,
	[Parameter(Mandatory=$true)]
    [String] $destination
)
{
	Write-Host "Source: $source"

	$client = New-Object System.Net.WebClient
	$Global:downloadComplete = $false

	$eventDataComplete = Register-ObjectEvent $client DownloadFileCompleted `
		-SourceIdentifier WebClient.DownloadFileComplete `
		-Action {$Global:downloadComplete = $true}
	$eventDataProgress = Register-ObjectEvent $client DownloadProgressChanged `
		-SourceIdentifier WebClient.DownloadProgressChanged `
		-Action { $Global:DPCEventArgs = $EventArgs }  
	$client.Proxy.Credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials
	
	$cookie = "oraclelicense=accept-securebackup-cookie"
	$client.Headers.Add([System.Net.HttpRequestHeader]::Cookie, $cookie) 
	
	$client.downloadFileAsync($source, $destination)

	while (!($Global:downloadComplete)) {                
		$pc = $Global:DPCEventArgs.ProgressPercentage
		if ($pc -ne $null) {
			Write-Progress -Activity 'Downloading file' -Status $source -PercentComplete $pc
		}
	}


	Unregister-Event -SourceIdentifier WebClient.DownloadProgressChanged
	Unregister-Event -SourceIdentifier WebClient.DownloadFileComplete
	$client.Dispose()
	$Global:downloadComplete = $null
	$Global:DPCEventArgs = $null
	Remove-Variable client
	Remove-Variable eventDataComplete
	Remove-Variable eventDataProgress
	[GC]::Collect()  
}

function Expand-ZIPFile($file, $destination)
{
	$shell = new-object -com shell.application
	$zip = $shell.NameSpace($file)
	foreach($item in $zip.items())
	{
		$shell.Namespace($destination).copyhere($item, 20)
	}
}

function Create-Shortcut($name, $file)
{
	$WshShell = New-Object -comObject WScript.Shell
	$Shortcut = $WshShell.CreateShortcut($env:USERPROFILE+"\Desktop\$name.lnk")
	$Shortcut.TargetPath = $file
	$Shortcut.IconLocation = $file
	$Shortcut.Save()
}