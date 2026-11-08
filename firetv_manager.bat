@echo off
chcp 65001 > nul
title Fire TV 4K / MAX Optimizer & Sideload Suite

:MENU
cls
echo ==============================================================
echo       FIRE TV 4K / MAX - SUITE DE OPTIMIZACIÓN Y GESTIÓN
echo ==============================================================
echo  1. Conectar por ADB al Fire TV
echo  2. Auditar paquetes instalados y estado del dispositivo
echo  3. Optimizar y Desactivar Telemetría / Anuncios (Debloat Seguro)
echo  4. Activar DNS Privado Anti-Publicidad (AdGuard DNS)
echo  5. Acelerar interfaz y animaciones (0.5x respuesta rápida)
echo  6. Cerrar todas las Apps en segundo plano y liberar RAM
echo  7. Limpieza profunda de Caché y Archivos Basura (Sin borrar cuentas)
echo  8. Instalar aplicaciones APK de la carpeta /apks (Sin Downloader)
echo  9. Optimización Completa 1-Click (Pasos 3, 4, 5, 6 y 7)
echo  10. Sincronizar suite local con la Skill oficial Antigravity
echo  11. Deshacer cambios / Restaurar todo a valores de fábrica
echo  12. Salir
echo ==============================================================
set /p opt="Selecciona una opción [1-12]: "

if "%opt%"=="1" (
    powershell -ExecutionPolicy Bypass -File "%~dp0scripts\01_connect.ps1"
    pause
    goto MENU
)
if "%opt%"=="2" (
    powershell -ExecutionPolicy Bypass -File "%~dp0scripts\02_audit_packages.ps1"
    pause
    goto MENU
)
if "%opt%"=="3" (
    powershell -ExecutionPolicy Bypass -File "%~dp0scripts\03_debloat_safe.ps1"
    pause
    goto MENU
)
if "%opt%"=="4" (
    powershell -ExecutionPolicy Bypass -File "%~dp0scripts\04_dns_adblock.ps1"
    pause
    goto MENU
)
if "%opt%"=="5" (
    powershell -ExecutionPolicy Bypass -File "%~dp0scripts\06_optimize_ui.ps1"
    pause
    goto MENU
)
if "%opt%"=="6" (
    powershell -ExecutionPolicy Bypass -File "%~dp0scripts\08_close_background_apps.ps1"
    pause
    goto MENU
)
if "%opt%"=="7" (
    powershell -ExecutionPolicy Bypass -File "%~dp0scripts\09_deep_cache_cleanup.ps1"
    pause
    goto MENU
)
if "%opt%"=="8" (
    powershell -ExecutionPolicy Bypass -File "%~dp0scripts\05_install_apk.ps1"
    pause
    goto MENU
)
if "%opt%"=="9" (
    echo.
    echo [*] Ejecutando Optimización Completa al 100%...
    powershell -ExecutionPolicy Bypass -File "%~dp0scripts\03_debloat_safe.ps1"
    powershell -ExecutionPolicy Bypass -File "%~dp0scripts\04_dns_adblock.ps1"
    powershell -ExecutionPolicy Bypass -File "%~dp0scripts\06_optimize_ui.ps1"
    powershell -ExecutionPolicy Bypass -File "%~dp0scripts\08_close_background_apps.ps1"
    powershell -ExecutionPolicy Bypass -File "%~dp0scripts\09_deep_cache_cleanup.ps1"
    echo [+] Optimización finalizada con éxito.
    pause
    goto MENU
)
if "%opt%"=="10" (
    powershell -ExecutionPolicy Bypass -File "%~dp0sync_suite.ps1"
    pause
    goto MENU
)
if "%opt%"=="11" (
    powershell -ExecutionPolicy Bypass -File "%~dp0scripts\99_restore_all.ps1"
    pause
    goto MENU
)
if "%opt%"=="12" (
    exit /b 0
)

echo Opción no válida.
pause
goto MENU
