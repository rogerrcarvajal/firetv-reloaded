$adb = "c:\xampp\htdocs\amazon-firetv\tools\platform-tools\adb.exe"
. "$PSScriptRoot\common_adb.ps1"
Ensure-AdbConnected -AdbPath $adb
$logsDir = "c:\xampp\htdocs\amazon-firetv\logs"
$debloatLog = "$logsDir\debloated_packages.txt"

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "       RESTAURACION COMPLETA / REVERSION DE CAMBIOS        " -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan

if (Test-Path $debloatLog) {
    $packages = Get-Content $debloatLog
    Write-Host "[*] Reactivando $($packages.Count) paquetes registrados previamente..." -ForegroundColor Cyan
    foreach ($pkg in $packages) {
        if (-not [string]::IsNullOrWhiteSpace($pkg)) {
            Write-Host -NoNewline "[*] Reactivando $pkg ... "
            $res = & $adb shell pm enable $pkg 2>&1
            Write-Host "$res" -ForegroundColor Green
        }
    }
} else {
    Write-Host "[!] No se encontro el archivo de registro $debloatLog." -ForegroundColor Yellow
    Write-Host "[*] Reactivando lista estandar de servicios..." -ForegroundColor Cyan
    $defaultList = @(
        "com.amazon.advertising.firetv",
        "com.amazon.device.logmanager",
        "com.amazon.client.metrics",
        "com.amazon.usage.collection",
        "com.amazon.visualsearch",
        "com.amazon.fv"
    )
    foreach ($pkg in $defaultList) {
        & $adb shell pm enable $pkg
    }
}

Write-Host "`n[*] Restableciendo animaciones a valor de fabrica (1.0)..." -ForegroundColor Cyan
& $adb shell settings put global window_animation_scale 1.0
& $adb shell settings put global transition_animation_scale 1.0
& $adb shell settings put global animator_duration_scale 1.0

Write-Host "[*] Restableciendo DNS Privado a modo automatico..." -ForegroundColor Cyan
& $adb shell settings put global private_dns_mode off
& $adb shell settings delete global private_dns_specifier

Write-Host "`n[+] Restauracion completada con exito." -ForegroundColor Green
