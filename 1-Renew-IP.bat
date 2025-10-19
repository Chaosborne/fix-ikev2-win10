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
echo === TEST 4: Renew IP Addresses ===
echo ========================================
echo.

echo Renewing IP addresses...
ipconfig /renew >nul 2>&1

echo ✓ IP addresses renewed
echo.
echo Now try to connect to VPN through Windows tray
echo.
pause