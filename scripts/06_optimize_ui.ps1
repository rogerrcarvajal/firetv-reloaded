$adb = "c:\xampp\htdocs\amazon-firetv\tools\platform-tools\adb.exe"
. "$PSScriptRoot\common_adb.ps1"
Ensure-AdbConnected -AdbPath $adb

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "       ACELERACION DE INTERFAZ Y RESPUESTA DEL MANDO       " -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "[*] Ajustando escalas de animacion a 0.5x (Mayor agilidad)..." -ForegroundColor Gray

& $adb shell settings put global window_animation_scale 0.5
& $adb shell settings put global transition_animation_scale 0.5
& $adb shell settings put global animator_duration_scale 0.5

Write-Host "[+] Escala de ventana: " (& $adb shell settings get global window_animation_scale)
Write-Host "[+] Escala de transicion: " (& $adb shell settings get global transition_animation_scale)
Write-Host "[+] Escala de animador: " (& $adb shell settings get global animator_duration_scale)

Write-Host "`n[+] La interfaz y el control remoto ahora responderan con mayor rapidez." -ForegroundColor Green
