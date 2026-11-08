$ErrorActionPreference = "Stop"
$toolsDir = "c:\xampp\htdocs\amazon-firetv\tools"
$zipPath = "$toolsDir\platform-tools.zip"
$zipUrl = "https://dl.google.com/android/repository/platform-tools-latest-windows.zip"

if (-not (Test-Path $toolsDir)) {
    New-Item -ItemType Directory -Force -Path $toolsDir | Out-Null
}

$adbExe = "$toolsDir\platform-tools\adb.exe"
if (Test-Path $adbExe) {
    Write-Host "ADB ya se encuentra instalado en: $adbExe"
    & $adbExe version
    exit 0
}

Write-Host "Descargando Android platform-tools desde Google..."
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri $zipUrl -OutFile $zipPath

Write-Host "Extrayendo platform-tools..."
Expand-Archive -Path $zipPath -DestinationPath $toolsDir -Force
Remove-Item $zipPath -Force

if (Test-Path $adbExe) {
    Write-Host "ADB instalado correctamente:"
    & $adbExe version
} else {
    Write-Error "No se encontro adb.exe tras la descompresion"
    exit 1
}
