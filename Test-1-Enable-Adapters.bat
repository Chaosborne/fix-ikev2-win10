@echo off
setlocal enabledelayedexpansion

:: Check admin rights
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Administrator rights required, restarting...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

echo ========================================
echo === TEST 1: Enable Network Adapters ===
echo ========================================
echo.

echo Enabling all disabled network adapters...
powershell -Command "Get-NetAdapter | Where-Object {$_.Status -eq 'Disabled'} | Enable-NetAdapter" >nul 2>&1

echo ✓ Adapters enabled
echo.
echo Now try to connect to VPN through Windows tray
echo.
pause