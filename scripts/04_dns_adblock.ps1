param (
    [string]$DnsProvider = "dns.adguard-dns.com"
)

$adb = "c:\xampp\htdocs\amazon-firetv\tools\platform-tools\adb.exe"
& $adb connect 10.10.10.28:5555 | Out-Null

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "       CONFIGURACION DE DNS PRIVADO ANTI-PUBLICIDAD        " -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan
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
