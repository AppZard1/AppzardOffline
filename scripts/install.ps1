Add-Type -AssemblyName System.IO.Compression.FileSystem
function Unzip
{
    param([string]$zipfile, [string]$outpath)

    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}
function Create-Directory {
  param (
        $DirectoryName
    )
    if (-not (Test-Path -Path $DirectoryName)) {
      New-Item -ItemType directory -Path $DirectoryName
    }
}
Write-Host Starting Appzard installation..
$appengine=$(Invoke-RestMethod "https://appzardoffline-default-rtdb.firebaseio.com/appengine.json")
$build=$(Invoke-RestMethod "https://appzardoffline-default-rtdb.firebaseio.com/build.json")
$buildserver=$(Invoke-RestMethod "https://appzardoffline-default-rtdb.firebaseio.com/buildserver.json")
$bindir="$HOME\.appzard\bin"
$appdata="$env:APPDATA\appzard\"
Create-Directory $appdata
Create-Directory $appdata\deps
Create-Directory $appdata\scripts
Create-Directory $bindir
Write-Host Downloading Appzard executable..
Invoke-WebRequest https://raw.githubusercontent.com/AppZard1/AppzardOffline/main/bin/windows/appzard.exe -OutFile "$bindir\appzard.exe"
Write-Host -ForegroundColor Green Done!
Write-Host Downloading Appengine Java SDK..
Invoke-WebRequest $appengine -OutFile "$appdata\deps\appengine.zip"
Write-Host -ForegroundColor Green Done!
Write-Host Downloading Build files..
Invoke-WebRequest $build -OutFile "$appdata\deps\build.zip"
Write-Host -ForegroundColor Green Done!
Write-Host Downloading Buildserver files..
Invoke-WebRequest $buildserver -OutFile "$appdata\deps\buildserver.zip"
Write-Host -ForegroundColor Green Done!
Write-Host Downloading Upgrade Script..
Invoke-WebRequest https://raw.githubusercontent.com/AppZard1/AppzardOffline/main/scripts/upgrade.sh -OutFile "$appdata\scripts\upgrade.sh"
Write-Host -ForegroundColor Green Done!
Write-Host Unpacking files..
if (Test-Path $appdata\deps\build) {
  Remove-Item -Recurse $appdata\deps\build
}
if (Test-Path $appdata\deps\appengine) {
  Remove-Item -Recurse $appdata\deps\appengine
}
if (Test-Path $appdata\deps\buildserver) {
  Remove-Item -Recurse $appdata\deps\buildserver
}
Unzip "$appdata\deps\build.zip" "$appdata\deps\build"
Unzip "$appdata\deps\appengine.zip" "$appdata\deps\appengine"
Unzip "$appdata\deps\buildserver.zip" "$appdata\deps\buildserver"
Remove-Item "$appdata\deps\build.zip"
Remove-Item "$appdata\deps\appengine.zip"
Remove-Item "$appdata\deps\buildserver.zip"
Write-Host -ForegroundColor Green Done!
$env:Path += ";$bindir"
Write-Host -ForegroundColor Yellow Appzard Has been successfully installed at $bindir\appzard.exe!