$adb = "c:\xampp\htdocs\amazon-firetv\tools\platform-tools\adb.exe"
& $adb connect 10.10.10.28:5555 | Out-Null

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "         LIMPIEZA PROFUNDA DE CACHÉ Y ARCHIVOS BASURA     " -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "[i] No borra cuentas, inicios de sesión ni configuraciones.`n" -ForegroundColor Gray

# Espacio antes
$spaceBefore = (& $adb shell df -h /data | Select-Object -Last 1).Trim()
Write-Host "[*] Almacenamiento previo: $spaceBefore" -ForegroundColor Gray

Write-Host "[*] Purgando buffers y cachés acumuladas de aplicaciones..." -ForegroundColor Cyan
& $adb shell "pm trim-caches 4000M" | Out-Null

Write-Host "[*] Eliminando temporales y miniaturas residuales (.thumbnails)..." -ForegroundColor Cyan
& $adb shell "rm -rf /sdcard/.thumbnails/*" 2>$null
& $adb shell "rm -rf /sdcard/Android/data/*/cache/*" 2>$null
& $adb shell "rm -rf /data/local/tmp/*" 2>$null

# Forzar recolección de basura del sistema
& $adb shell "echo 3 > /proc/sys/vm/drop_caches" 2>$null

Start-Sleep -Seconds 2

# Espacio después
$spaceAfter = (& $adb shell df -h /data | Select-Object -Last 1).Trim()

Write-Host "`n==========================================================" -ForegroundColor Cyan
Write-Host "[+] Limpieza profunda completada con éxito." -ForegroundColor Green
Write-Host "[*] Almacenamiento tras la limpieza: $spaceAfter" -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Cyan
