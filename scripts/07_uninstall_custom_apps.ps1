$adb = "c:\xampp\htdocs\amazon-firetv\tools\platform-tools\adb.exe"
& $adb connect 10.10.10.28:5555 | Out-Null

$pkgs = @(
    "co.si.du.supercleaner",
    "com.nst.iptvsmarterstvbox",
    "com.lbe.parallel.intl",
    "com.peacock.peacockfiretv",
    "com.biomes.vanced",
    "com.vectormax.tv.viginet"
)

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "         DESINSTALACION DE APPS SOLICITADAS               " -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan

foreach ($pkg in $pkgs) {
    Write-Host -NoNewline "[*] Desinstalando $pkg ... "
    $res = (& $adb uninstall $pkg).Trim()
    if ($res -like "*Success*") {
        Write-Host "DESINSTALADO CON EXITO [OK]" -ForegroundColor Green
    } else {
        Write-Host "Resultado: $res" -ForegroundColor Gray
    }
}
