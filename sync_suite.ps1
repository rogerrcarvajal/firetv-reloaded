$ErrorActionPreference = "Stop"

$workspaceScripts = "c:\xampp\htdocs\amazon-firetv\scripts"
$skillScripts = "C:\Users\Administrator\.gemini\config\skills\firetv-reloaded\scripts"

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "     SINCRONIZACION INTEGRAL DE LA SUITE FIRETV-RELOADED  " -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan

if (-not (Test-Path $skillScripts)) {
    New-Item -ItemType Directory -Force -Path $skillScripts | Out-Null
}

$files = Get-ChildItem -Path $workspaceScripts -Filter "*.ps1"
Write-Host "[*] Sincronizando $($files.Count) scripts hacia la Skill oficial..." -ForegroundColor Gray

foreach ($f in $files) {
    Copy-Item -Path $f.FullName -Destination $skillScripts -Force
    Write-Host "    [v] Sincronizado: $($f.Name)" -ForegroundColor Green
}

Write-Host "`n[+] Todas las instancias de la suite estan sincronizadas al 100%." -ForegroundColor Green
