param (
    [string]$DnsProvider = "dns.adguard-dns.com"
)

$adb = "c:\xampp\htdocs\amazon-firetv\tools\platform-tools\adb.exe"
. "$PSScriptRoot\common_adb.ps1"
Ensure-AdbConnected -AdbPath $adb

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "       CONFIGURACION DE DNS PRIVADO ANTI-PUBLICIDAD        " -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan

# Comprobar versión de Android / Fire OS
$sdk = (& $adb shell getprop ro.build.version.sdk).Trim()
$fireos = (& $adb shell getprop ro.build.version.name).Trim()

if ([int]$sdk -lt 28) {
    Write-Host "[!] Dispositivo detectado: $fireos (Android SDK $sdk - Fire OS 6/5)." -ForegroundColor Yellow
    Write-Host "[!] La funcion nativa de 'Private DNS (DoT)' requiere Android 9+ (Fire OS 7/8)." -ForegroundColor Yellow
    Write-Host "[*] El bloqueo de anuncios en este modelo opera mediante la desactivacion" -ForegroundColor Cyan
    Write-Host "    de paquetes de telemetria/ads y puede complementarse con DNS en el Router.`n" -ForegroundColor Cyan
} else {
    Write-Host "Servidor configurado: $DnsProvider" -ForegroundColor Gray
    Write-Host "Bloquea anuncios en aplicaciones, rastreadores y banners a nivel de red.`n" -ForegroundColor Gray

    & $adb shell settings put global private_dns_mode hostname
    & $adb shell settings put global private_dns_specifier $DnsProvider

    $currentMode = (& $adb shell settings get global private_dns_mode).Trim()
    $currentHost = (& $adb shell settings get global private_dns_specifier).Trim()

    if ($currentHost -eq $DnsProvider) {
        Write-Host "[+] DNS Privado configurado con exito:" -ForegroundColor Green
        Write-Host "    - Modo: $currentMode"
        Write-Host "    - Host: $currentHost"
    } else {
        Write-Host "[!] Respuesta del sistema: Modo: $currentMode, Host: $currentHost" -ForegroundColor Yellow
    }
}
