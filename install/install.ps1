. ".\utils.ps1"
. ".\install-STS.ps1"
. ".\install-gradle.ps1"
. ".\install-jdk.ps1"

echo "Starting installation..."

$TEMP_DIR="C:\install-temp"
$INSTALL_DIR="C:\dev\install-temp"

New-Item -ItemType Directory -Force -Path $TEMP_DIR | Out-Null
New-Item -ItemType Directory -Force -Path $INSTALL_DIR | Out-Null

# =============== JDK ===============

install-JDK $INSTALL_DIR
exit 0
# =============== JDK ===============

# =============== Spring STS ===============

install-STS $INSTALL_DIR

# ============= END Spring STS =============

# ================= Gradle =================

install-Gradle $INSTALL_DIR

#Create-Shortcut -Name "Gradle" -File "$INSTALL_DIR\gradle-$GRADLE_VERSION\bin\gradle.bat"

# =============== END Gradle ===============

# ================= Conemu =================

$source = "https://github.com/Maximus5/ConEmu/releases/download/v16.12.06/ConEmuPack.161206.7z"
$destination = "$TEMP_DIR\ConEmuPack.161206.7z"

Write-Host "Downloading ConEmu ..."
downloadFile $source $destination
Write-Host "Done."

Expand-ZIPFile -File $destination -Destination $INSTALL_DIR

# =============== END Conemu ===============

Remove-Item $TEMP_DIR -Recurse






$cookie = "oraclelicense=accept-securebackup-cookie"
$client.Headers.Add([System.Net.HttpRequestHeader]::Cookie, $cookie)


# Setup Environment Variables

#[Environment]::SetEnvironmentVariable("artifactory_username","gradleuser","User")
#[Environment]::SetEnvironmentVariable("artifactory_password","gradleuser","User")






























exit 0










$JDK_VER="8u111"
$JDK_FULL_VER="8u111-b14"
$JDK_PATH="1.7.0_75"
$source86 = "http://download.oracle.com/otn-pub/java/jdk/$JDK_FULL_VER/jdk-$JDK_VER-windows-i586.exe"
$source64 = "http://download.oracle.com/otn-pub/java/jdk/8u111-b14/jdk-8u111-windows-x64.exe"
$destination86 = "C:\vagrant\$JDK_VER-x86.exe"
$destination64 = "C:\vagrant\$JDK_VER-x64.exe"
$client = new-object System.Net.WebClient
$cookie = "oraclelicense=accept-securebackup-cookie"
$client.Headers.Add([System.Net.HttpRequestHeader]::Cookie, $cookie)
 
#Write-Host 'Checking if Java is already installed'
#if ((Test-Path "c:\Program Files (x86)\Java") -Or (Test-Path "c:\Program Files\Java")) {
#    Write-Host 'No need to Install Java'
#    Exit
#}
 
Write-Host "Downloading x86 to $destination86"
 
Write-Host "Source: $source86"
Write-Host "Destination: $destination86"
 
$client.downloadFile($source86, $destination86)
if (!(Test-Path $destination86)) {
    Write-Host "Downloading $destination86 failed"
    Exit
}
Write-Host 'Downloading x64 to $destination64'
 
$client.downloadFile($source64, $destination64)
if (!(Test-Path $destination64)) {
    Write-Host "Downloading $destination64 failed"
    Exit
}
 
 
try {
    Write-Host 'Installing JDK-x64'
    $proc1 = Start-Process -FilePath "$destination64" -ArgumentList "/s REBOOT=ReallySuppress" -Wait -PassThru
    $proc1.waitForExit()
    Write-Host 'Installation Done.'
 
    Write-Host 'Installing JDK-x86'
    $proc2 = Start-Process -FilePath "$destination86" -ArgumentList "/s REBOOT=ReallySuppress" -Wait -PassThru
    $proc2.waitForExit()
    Write-Host 'Installtion Done.'
} catch [exception] {
    write-host '$_ is' $_
    write-host '$_.GetType().FullName is' $_.GetType().FullName
    write-host '$_.Exception is' $_.Exception
    write-host '$_.Exception.GetType().FullName is' $_.Exception.GetType().FullName
    write-host '$_.Exception.Message is' $_.Exception.Message
}
 
if ((Test-Path "c:\Program Files (x86)\Java") -Or (Test-Path "c:\Program Files\Java")) {
    Write-Host 'Java installed successfully.'
}
Write-Host 'Setting up Path variables.'
[System.Environment]::SetEnvironmentVariable("JAVA_HOME", "c:\Program Files (x86)\Java\jdk$JDK_PATH", "Machine")
[System.Environment]::SetEnvironmentVariable("PATH", $Env:Path + ";c:\Program Files (x86)\Java\jdk$JDK_PATH\bin", "Machine")
Write-Host 'Done. Goodbye.'