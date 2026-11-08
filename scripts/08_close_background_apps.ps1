$adb = "c:\xampp\htdocs\amazon-firetv\tools\platform-tools\adb.exe"
. "$PSScriptRoot\common_adb.ps1"
Ensure-AdbConnected -AdbPath $adb

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "     CIERRE TOTAL DE APLICACIONES EN SEGUNDO PLANO        " -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan

# Memoria antes
$memBefore = & $adb shell "cat /proc/meminfo | grep -E 'MemTotal|MemFree|MemAvailable'"
Write-Host "[*] Estado de memoria previo:" -ForegroundColor Gray
$memBefore | ForEach-Object { Write-Host "    $_" }

# Obtener lista de paquetes de terceros instalados
$thirdParty = (& $adb shell pm list packages -3) -replace "^package:", ""

# Apps adicionales de streaming y paneles que consumen RAM en segundo plano
$extraApps = @(
    "com.amazon.smarthomemapviewapp",
    "com.amazon.firetv.youtube",
    "com.amazon.firetv.youtube.tv",
    "com.amazon.avod",
    "com.amazon.venezia"
)

$allToStop = ($thirdParty + $extraApps) | Select-Object -Unique

Write-Host "`n[*] Cerrando forzosamente $($allToStop.Count) aplicaciones en segundo plano..." -ForegroundColor Cyan
$stoppedCount = 0

foreach ($pkg in $allToStop) {
    if (-not [string]::IsNullOrWhiteSpace($pkg)) {
        & $adb shell am force-stop $pkg
        Write-Host "    [x] Cerrada: $pkg" -ForegroundColor Green
        $stoppedCount++
    }
}

# Volver a la pantalla de inicio limpia
& $adb shell input keyevent 3

# Liberar cachés en memoria
& $adb shell "echo 3 > /proc/sys/vm/drop_caches" 2>$null

Start-Sleep -Seconds 2

# Memoria después
$memAfter = & $adb shell "cat /proc/meminfo | grep -E 'MemTotal|MemFree|MemAvailable'"

Write-Host "`n==========================================================" -ForegroundColor Cyan
Write-Host "[+] Proceso completado: $stoppedCount aplicaciones cerradas." -ForegroundColor Green
Write-Host "[*] Estado de memoria tras la liberacion:" -ForegroundColor Cyan
$memAfter | ForEach-Object { Write-Host "    $_" -ForegroundColor Green }
Write-Host "==========================================================" -ForegroundColor Cyan
