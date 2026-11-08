param (
    [string]$FireTvIp = ""
)

$adb = "c:\xampp\htdocs\amazon-firetv\tools\platform-tools\adb.exe"

if (-not (Test-Path $adb)) {
    Write-Host "[!] ADB no encontrado. Ejecutando instalacion de herramientas..." -ForegroundColor Yellow
    & powershell -ExecutionPolicy Bypass -File "c:\xampp\htdocs\amazon-firetv\setup_tools.ps1"
}

if ([string]::IsNullOrWhiteSpace($FireTvIp)) {
    $FireTvIp = Read-Host "Ingresa la direccion IP de tu Fire TV"
}

Write-Host "`n[*] Conectando a $FireTvIp:5555 via ADB..." -ForegroundColor Cyan
& $adb connect "${FireTvIp}:5555"

Write-Host "`n[*] Verificando dispositivos conectados:" -ForegroundColor Cyan
& $adb devices -l

Write-Host "`n[i] Si en tu Fire TV aparece el mensaje '¿Permitir depuración USB/ADB?'," -ForegroundColor Yellow
Write-Host "    marca la casilla 'Permitir siempre desde este equipo' y presiona Aceptar con el control remoto.`n" -ForegroundColor Yellow
