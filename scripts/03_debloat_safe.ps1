$adb = "c:\xampp\htdocs\amazon-firetv\tools\platform-tools\adb.exe"
& $adb connect 10.10.10.28:5555 | Out-Null
$logsDir = "c:\xampp\htdocs\amazon-firetv\logs"
$debloatLog = "$logsDir\debloated_packages.txt"

# Paquetes de telemetría, publicidad innecesaria y servicios pesados de fondo verificados para Fire OS 7 / 8
# NOTA: Se conserva 100% intacto com.amazon.tv.launcher para mantener la pantalla de inicio original.
$bloatPackages = @(
    "com.amazon.advertising.firetv",
    "com.amazon.device.logmanager",
    "com.amazon.client.metrics",
    "com.amazon.usage.collection",
    "com.amazon.visualsearch",
    "com.amazon.fv",
    "com.amazon.ods.kindleconnect",
    "com.amazon.shopping.myx",
    "com.amazon.shpm",
    "com.amazon.kor.soho",
    "com.amazon.device.sale.service",
    "com.amazon.device.sync",
    "com.amazon.tahoe",
    "com.amazon.tv.nimh",
    "com.amazon.whisperjoin.middleware.fl",
    "com.amazon.altair.services",
    "com.amazon.bueller.music",
    "com.amazon.bueller.photos",
    "com.amazon.kindle.unifiedSearch"
)

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "     OPTIMIZACION SEGURA (DEBLOAT NO DESTRUCTIVO)         " -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "Estrategia: pm disable-user --user 0 (Reversible al 100%)" -ForegroundColor Gray
Write-Host "Pantalla de inicio (Launcher) preservada al 100% intacta.`n" -ForegroundColor Gray

$disabledCount = 0
$debloatedList = [System.Collections.Generic.List[string]]::new()

foreach ($pkg in $bloatPackages) {
    Write-Host -NoNewline "[*] Congelando $pkg ... "
    $res = (& $adb shell pm disable-user --user 0 $pkg 2>&1).Trim()
    if ($res -like "*disabled-user*" -or $res -like "*new state: disabled*") {
        Write-Host "DESACTIVADO CON EXITO [OK]" -ForegroundColor Green
        $debloatedList.Add($pkg)
        $disabledCount++
    } elseif ($res -like "*not installed*") {
        Write-Host "NO PRESENTE (Omitido)" -ForegroundColor DarkGray
    } else {
        Write-Host "Resultado: $res" -ForegroundColor Gray
    }
}

if (-not (Test-Path $logsDir)) {
    New-Item -ItemType Directory -Force -Path $logsDir | Out-Null
}
$debloatedList | Set-Content -Path $debloatLog -Encoding utf8

Write-Host "`n==========================================================" -ForegroundColor Cyan
Write-Host "[+] Proceso completado: $disabledCount servicios de telemetria y anuncios desactivados." -ForegroundColor Green
Write-Host "    Registro guardado para restauracion en: $debloatLog" -ForegroundColor Gray
Write-Host "==========================================================" -ForegroundColor Cyan
