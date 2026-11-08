$adb = "c:\xampp\htdocs\amazon-firetv\tools\platform-tools\adb.exe"
. "$PSScriptRoot\common_adb.ps1"
Ensure-AdbConnected -AdbPath $adb

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "     DESINSTALACION DE APLICACIONES SELECCIONADAS         " -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan

# Lista completa de palabras clave solicitadas por el usuario:
# - Supercleaner, IPTV Smarters Pro, Parallel Space, Peacock TV, Vanced, TVee
# - Magma, Pley, Screen Mirror
$targetKeywords = @(
    "cleaner", "superclean",
    "iptvsmarters", "smartersplayer", "nst.iptv",
    "parallel",
    "peacock",
    "vanced",
    "tvee", "vectormax",
    "magma",
    "pley",
    "screenmirror", "screen.mirror", "airplay"
)

Write-Host "[*] Buscando paquetes de terceros instalados que coincidan con la lista..." -ForegroundColor Cyan
$thirdPartyPackages = (& $adb shell pm list packages -3) -replace "^package:", ""

$packagesToRemove = [System.Collections.Generic.List[string]]::new()
foreach ($pkg in $thirdPartyPackages) {
    $pkgLower = $pkg.ToLower()
    foreach ($kw in $targetKeywords) {
        if ($pkgLower.Contains($kw)) {
            $packagesToRemove.Add($pkg)
            break
        }
    }
}

if ($packagesToRemove.Count -eq 0) {
    Write-Host "[!] No se encontraron paquetes coincidentes directamente en la lista instalada." -ForegroundColor Yellow
    Write-Host "[*] Aplicaciones de terceros instaladas actualmente en el dispositivo:" -ForegroundColor Cyan
    $thirdPartyPackages | ForEach-Object { Write-Host "    - $_" -ForegroundColor DarkGray }
} else {
    Write-Host "[+] Se encontraron $($packagesToRemove.Count) paquetes para desinstalar:" -ForegroundColor Green
    $packagesToRemove | ForEach-Object { Write-Host "    - $_" -ForegroundColor Yellow }

    foreach ($pkg in $packagesToRemove) {
        Write-Host -NoNewline "[*] Desinstalando $pkg ... "
        $res = (& $adb uninstall $pkg).Trim()
        if ($res -like "*Success*") {
            Write-Host "DESINSTALADO CON EXITO [OK]" -ForegroundColor Green
        } else {
            Write-Host "$res" -ForegroundColor Gray
        }
    }
}
