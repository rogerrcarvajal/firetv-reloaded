$adb = "c:\xampp\htdocs\amazon-firetv\tools\platform-tools\adb.exe"
$logsDir = "c:\xampp\htdocs\amazon-firetv\logs"

if (-not (Test-Path $logsDir)) {
    New-Item -ItemType Directory -Force -Path $logsDir | Out-Null
}

Write-Host "[*] Comprobando comunicacion con Fire TV..." -ForegroundColor Cyan
$device = & $adb get-state 2>$null
if ($device -ne "device") {
    Write-Host "[!] El Fire TV no esta listo o no esta autorizado (Estado: $device)." -ForegroundColor Red
    Write-Host "[!] Revisa la pantalla de tu TV y acepta la autorizacion RSA con el mando." -ForegroundColor Yellow
    exit 1
}

$model = (& $adb shell getprop ro.product.model).Trim()
$version = (& $adb shell getprop ro.build.version.incremental).Trim()
$fireos = (& $adb shell getprop ro.build.version.name).Trim()

Write-Host "`n[+] Dispositivo conectado exitosamente!" -ForegroundColor Green
Write-Host "    - Modelo: $model"
Write-Host "    - Fire OS: $fireos ($version)"

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$logFile = "$logsDir\packages_$timestamp.txt"
$activeFile = "$logsDir\packages_active.txt"

Write-Host "`n[*] Extrayendo lista completa de paquetes del sistema..." -ForegroundColor Cyan
& $adb shell pm list packages -f > $logFile
& $adb shell pm list packages > $activeFile

$count = (Get-Content $activeFile).Count
Write-Host "[+] Se encontraron $count paquetes instalados." -ForegroundColor Green
Write-Host "    Respaldo guardado en: $logFile"
