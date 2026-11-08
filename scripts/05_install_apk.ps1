param (
    [string]$ApkPath = ""
)

$adb = "c:\xampp\htdocs\amazon-firetv\tools\platform-tools\adb.exe"
$apksDir = "c:\xampp\htdocs\amazon-firetv\apks"

if (-not (Test-Path $apksDir)) {
    New-Item -ItemType Directory -Force -Path $apksDir | Out-Null
}

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "    INSTALADOR DIRECTO DE APLICACIONES (SIN DOWNLOADER)    " -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan

if (-not [string]::IsNullOrWhiteSpace($ApkPath)) {
    $targetApks = @($ApkPath)
} else {
    $targetApks = Get-ChildItem -Path $apksDir -Filter "*.apk" | ForEach-Object { $_.FullName }
}

if ($targetApks.Count -eq 0) {
    Write-Host "[!] No se especifico ningun APK ni se encontraron archivos .apk en la carpeta:" -ForegroundColor Yellow
    Write-Host "    $apksDir" -ForegroundColor Gray
    Write-Host "`nColoca tus archivos .apk en esa carpeta y vuelve a ejecutar este script." -ForegroundColor Cyan
    exit 0
}

foreach ($apk in $targetApks) {
    $name = Split-Path $apk -Leaf
    Write-Host "`n[*] Instalando $name en Fire TV..." -ForegroundColor Cyan
    $res = & $adb install -r -d "$apk" 2>&1
    if ($res -like "*Success*") {
        Write-Host "[+] $name instalado EXITOSAMENTE!" -ForegroundColor Green
    } else {
        Write-Host "[-] Error al instalar $name : $res" -ForegroundColor Red
    }
}
