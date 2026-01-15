$buildDir = Join-Path $PSScriptRoot "bin\Debug\net7.0-windows10.0.19041.0"
$sourceManifest = Join-Path $buildDir "Package.appxmanifest"
$targetManifest = Join-Path $buildDir "AppxManifest.xml"

if (-not (Test-Path $sourceManifest)) {
    Write-Error "Source Manifest not found at $sourceManifest. Did you build?"
    exit 1
}

Write-Host "Ensuring AppxManifest.xml exists..."
Copy-Item -Path $sourceManifest -Destination $targetManifest -Force

$packageName = "4CA98CE-D3A4-46E4-A11D-0BC0351412AD"
Write-Host "Removing existing package if present..."
Get-AppxPackage -Name $packageName | Remove-AppxPackage

Write-Host "Registering App..."
Add-AppxPackage -Register $targetManifest
Write-Host "Done!"
