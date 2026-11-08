$adb = "c:\xampp\htdocs\amazon-firetv\tools\platform-tools\adb.exe"
& $adb connect 10.10.10.28:5555 | Out-Null
$logsDir = "c:\xampp\htdocs\amazon-firetv\logs"
$debloatLog = "$logsDir\debloated_packages.txt"

# Paquetes de telemetría, publicidad innecesaria, Shop on Amazon y servicios pesados de fondo verificados
# NOTA: Se conserva 100% intacto com.amazon.tv.launcher para mantener la pantalla de inicio original.
$bloatPackages = @(
    "com.amazon.shoptv.firetv.client",
    "com.amazon.shoptv.client",
    "com.amazon.hybridadidservice",
    "com.amazon.whad",
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
    Write-Host -NoNewline "[*] Procesando $pkg ... "
    $res = (& $adb shell pm disable-user --user 0 $pkg 2>&1)
    $resStr = ($res | Out-String).Trim()
    if ($resStr -like "*disabled-user*" -or $resStr -like "*new state: disabled*") {
        Write-Host "DESACTIVADO CON EXITO [OK]" -ForegroundColor Green
        $debloatedList.Add($pkg)
        $disabledCount++
    } elseif ($resStr -like "*not installed*" -or $resStr -like "*Unknown package*") {
        Write-Host "NO PRESENTE (Omitido)" -ForegroundColor DarkGray
    } elseif ($resStr -like "*protected package*") {
        Write-Host "PROTEGIDO POR FIRE OS (Omitido)" -ForegroundColor Yellow
    } else {
        Write-Host "Resultado: $resStr" -ForegroundColor Gray
    }
}

Write-Host "`n[*] Forzando opt-out de publicidad y apagando reproduccion automatica..." -ForegroundColor Cyan
& $adb shell settings put secure advertising_id_opt_out 1
& $adb shell settings put global ad_tracking_enabled 0
& $adb shell settings put secure limit_ad_tracking 1
& $adb shell settings put secure non_amz_limit_ad_tracking 1
& $adb shell settings put global com.amazon.tv.settings.featured_item_video_enabled 0
& $adb shell settings put global com.amazon.tv.settings.featured_item_video_volume 0.0

if (-not (Test-Path $logsDir)) {
    New-Item -ItemType Directory -Force -Path $logsDir | Out-Null
}
$debloatedList | Set-Content -Path $debloatLog -Encoding utf8

Write-Host "`n==========================================================" -ForegroundColor Cyan
Write-Host "[+] Proceso completado: $disabledCount servicios desactivados y banners comerciales erradicados." -ForegroundColor Green
Write-Host "    Registro guardado para restauracion en: $debloatLog" -ForegroundColor Gray
Write-Host "==========================================================" -ForegroundColor Cyan
